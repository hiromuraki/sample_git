import os


def hello(name):
    return f"Hello, {name}!"


if __name__ == "__main__":
    user = os.getenv("USER_NAME", "World")
    print(hello(user))
