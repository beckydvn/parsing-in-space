import sys

from lark import Tree, Token
from pddl import parse_problem
from pddl.action import Action
from pddl.core import Domain, Problem
from pddl.parser import GRAMMAR_FILE
from pddl.logic.base import And, Or
from pddl.logic.functions import EqualTo
from pddl.logic.predicates import Predicate, DerivedPredicate
from pddl.logic.terms import Constant
from pddl.parser.base import BaseParser
from pddl.parser.problem import DomainTransformer, ProblemTransformer, Requirements
from pddl.helpers.base import assert_
from typing import Dict
import json

def tuple_to_dict(tup):
    """Process the 'problem_def' rule."""
    return {tup[0]: tup[1]}

class JSONDomainTransformer(DomainTransformer):
    """Domain Transformer that returns a JSON representation of the domain.
    
    NOTE: The pddl parser currently does not support PDDL+, but we provide the Domain Transformer template for the future.

    We also use this to hard-code the requirements for the problem, since the problem parser does not have access to the domain requirements.
    """

    def __init__(self) -> None:
        """Initialize the JSON domain transformer."""
        super().__init__()
        # import these: (:requirements :typing :negative-preconditions :conditional-effects :adl :fluents :equality)
        self._extended_requirements = {Requirements.TYPING, Requirements.NEG_PRECONDITION, Requirements.CONDITIONAL_EFFECTS, Requirements.ADL, Requirements.FLUENTS, Requirements.EQUALITY}

    def start(self, args):
        """Process the rule 'start'."""
        return {"domain": super().start(args)}
    
    def domain(self, args):
        """Process the 'domain' rule."""
        args = [arg for arg in args if arg is not None]
        kwargs = {}
        actions = []
        derived_predicates = []
        for arg in args[2:-1]:
            if isinstance(arg, Action):
                actions.append(arg)
            elif isinstance(arg, DerivedPredicate):
                derived_predicates.append(arg)
            else:
                assert_(isinstance(arg, dict))
                kwargs.update(arg)
        kwargs.update(actions=actions, derived_predicates=derived_predicates)
        self._types = None
        return kwargs

class JSONProblemTransformer(ProblemTransformer):
    """Problem Transformer that returns a JSON representation of the problem."""

    def __init__(self) -> None:
        """Initialize the JSON problem transformer."""
        super().__init__()

        self._domain_transformer = JSONDomainTransformer()
        self._objects_by_name: Dict[str, Constant] = {}
        # Methods that should be wrapped with tuple_to_dict
        dict_methods = {"problem_def", "problem_domain", "requirements", "objects", "init", "goal"}
        for method_name in dict_methods:
            parent_method = getattr(super(), method_name)
            setattr(self, method_name, lambda args, m=parent_method: tuple_to_dict(m(args)))

    def start(self, args):
        """Process the rule 'start'."""
        return {"problem": super().start(args)}
    
    def problem(self, args):
        """Process the 'problem' rule."""
        args = [arg for arg in args if arg is not None]
        assert_(
            (args[0].value + args[1].value + args[-1].value == "(define)"),
            "Problem should start with '(define' and close with ')'",
        )
        return {"define": args[2:-1]}

class JSONDomainParser(BaseParser[Domain]):
    """JSON PDDL domain parser class."""

    transformer_cls = JSONDomainTransformer
    start_symbol = "domain"

class JSONProblemParser(BaseParser[Problem]):
    """JSON PDDL problem parser class."""

    transformer_cls = JSONProblemTransformer
    start_symbol = "problem"

class JSONPDDLEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Constant):
            # we currently ignore type tags for the initial and goal state, but these can be added if needed.
            return {"name":obj.name,  "type": obj.type_tag} if obj.type_tag else {"name": obj.name}
        elif isinstance(obj, Predicate):
            return {"name": obj.name, "terms": obj.terms}
        elif isinstance(obj, Token):
            return obj.value
        elif isinstance(obj, Tree):
            return {obj.data: obj.children}
        elif isinstance(obj, EqualTo):
            return {"EqualTo": {"numeric_function": {"name": obj.operands[0].name, "terms": obj.operands[0].terms}, "value": obj.operands[1].value}}
        elif isinstance(obj, (And, Or)):
            return {f"{type(obj).__name__}": obj.operands}
        return super().default(obj)
    
def pddl_to_json(pddl_path: str, custom_parser: BaseParser):
    with open(GRAMMAR_FILE, "r") as f:
        grammar = f.read()
    with open(pddl_path, "r") as f:
        pddl_str = f.read()
    parser = custom_parser(grammar)
    result = parser(pddl_str)
    with open("output_json/problem.json", "w") as f:
        json.dump(result, f, cls=JSONPDDLEncoder, indent=4)

if __name__ == "__main__":
    # parse problem
    args = sys.argv
    problem_file = args[1] if len(args) > 1 else 'pddl_files/craftcollision1_problem.pddl'
    pddl_to_json(problem_file, JSONProblemParser)
