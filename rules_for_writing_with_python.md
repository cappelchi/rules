# Python Project Guidelines

## Rule 1: PEP 8 Compliance

**Description:** Follow PEP 8, the official style guide for Python code, to ensure consistency and readability.

**Good Example:**

```python

def calculate_area(radius):

"""Calculate the area of a circle given its radius."""

import math

return math.pi radius 2

```

**Bad Example:**

```python

def calculateArea( radius ):

"""Calculate the area of a circle given its radius."""

import math

return math.piradius2

```

## Rule 2: Meaningful Variable Names

**Description:** Use descriptive and meaningful names for variables to make the code self-explanatory.

**Good Example:**

```python

total_price = item_price quantity

```

**Bad Example:**

```python

x = a b

```

## Rule 3: Use of Docstrings

**Description:** Include docstrings in functions and classes to describe their purpose and usage.

**Good Example:**

```python

def add(a, b):

"""Return the sum of a and b."""

return a + b

```

**Bad Example:**

```python

def add(a, b):

return a + b

```

## Rule 4: Avoid Magic Numbers

**Description:** Use named constants instead of magic numbers to improve code clarity.

**Good Example:**

```python

MAX_CONNECTIONS = 5

if current_connections < MAX_CONNECTIONS:

connect()

```

**Bad Example:**

```python

if current_connections < 5:

connect()

```

## Rule 5: Error Handling

**Description:** Use try-except blocks to handle exceptions gracefully.

**Good Example:**

```python

try:

result = 10 / divisor

except ZeroDivisionError:

print("Cannot divide by zero.")

```

**Bad Example:**

```python

result = 10 / divisor

```

## Rule 6: Consistent Indentation

**Description:** Use 4 spaces per indentation level for consistency.

**Good Example:**

```python

def function():

if condition:

do_something()

```

**Bad Example:**

```python

def function():

if condition:

do_something()

```

## Rule 7: Limit Line Length

**Description:** Limit all lines to a maximum of 79 characters to improve readability.

**Good Example:**

```python

def long_function_name(var_one, var_two, var_three, var_four):

return var_one + var_two + var_three + var_four

```

**Bad Example:**

```python

def long_function_name(var_one, var_two, var_three, var_four, var_five, var_six, var_seven):

return var_one + var_two + var_three + var_four + var_five + var_six + var_seven

```

## Rule 8: Use List Comprehensions

**Description:** Use list comprehensions for creating lists in a concise and readable way.

**Good Example:**

```python

squares = [x2 for x in range(10)]

```

**Bad Example:**

```python

squares = []

for x in range(10):

squares.append(x2)

```

## Rule 9: Avoid Global Variables

**Description:** Minimize the use of global variables to reduce dependencies and side effects.

**Good Example:**

```python

def calculate_total(price, tax_rate):

return price + (price tax_rate)

```

**Bad Example:**

```python

tax_rate = 0.05

def calculate_total(price):

return price + (price tax_rate)

```

## Rule 10: Default Values

**Description:** As per PEP-008, use spaces around the = only for arguments that have both a type annotation and a default value.

**Good Example:**

```python

def func(a: int = 0) -> int:

pass

```

**Bad Example:**

```python

def func(a:int=0) -> int:

pass

```

## Rule 11: None type

**Description:** In the Python type system, NoneType is a “first class” type, and for typing purposes, None is an alias for NoneType. If an argument can be None, it has to be declared! You can use | union type expressions (recommended in new Python 3.10+ code), or the older Optional and Union syntaxes. Use explicit X | None instead of implicit.

**Good Example:**

```python

def modern_or_union(a: str | int | None, b: str | None = None) -> str:

pass

def union_optional(a: Union[str, int, None], b: Optional[str] = None) -> str:

pass

```

**Bad Example:**

```python

def nullable_union(a: Union[None, str]) -> str:

pass

def implicit_optional(a: str = None) -> str:

pass

```

## Rule 12: Type Annotation

**Description:** Annotate Python code with type hints according to PEP-484.

**Good Example:**

```python

def func(a: int) -> list[int]:

```

**Bad Example:**

```python

def func(a):

```
