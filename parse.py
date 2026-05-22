from lark import Tree, Token
from pddl import parse_problem
from pddl.core import Problem
from pddl.parser import GRAMMAR_FILE
from pddl.logic.base import And, Or
from pddl.logic.functions import EqualTo
from pddl.logic.predicates import Predicate
from pddl.logic.terms import Constant
from pddl.parser.base import BaseParser
from pddl.parser.problem import ProblemTransformer
from pddl.helpers.base import assert_
import json


class JSONProblemTransformer(ProblemTransformer):
    """Problem Transformer that returns a JSON representation of the problem."""

    def __init__(self) -> None:
        """Initialize the JSON problem transformer."""
        super().__init__()
        # Methods that should be wrapped with tuple_to_dict
        dict_methods = {"problem_def", "problem_domain", "requirements", "objects", "init", "goal"}
        for method_name in dict_methods:
            parent_method = getattr(super(), method_name)
            setattr(self, method_name, lambda args, m=parent_method: JSONProblemTransformer.tuple_to_dict(m(args)))

    @staticmethod
    def tuple_to_dict(tup):
        """Process the 'problem_def' rule."""
        return {tup[0]: tup[1]}

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
    

class JSONProblemParser(BaseParser[Problem]):
    """JSON PDDL problem parser class."""

    transformer_cls = JSONProblemTransformer
    start_symbol = "problem"

class JSONProblemEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Constant):
            return {"name":obj.name,  "type": obj.type_tag}
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

if __name__ == "__main__":
    problem_file = 'pddl_files/craftcollision1_problem.pddl'
    with open(GRAMMAR_FILE, "r") as f:
        grammar = f.read()
    f = open(problem_file, "r")
    problem_str = "\n".join(f.readlines())
    parser = JSONProblemParser(grammar)
    result = parser(problem_str)
    # write to file
    with open("problem.json", "w") as f:
        json.dump(result, f, cls=JSONProblemEncoder, indent=4)