import os


def hello(name):
    return f"Hello, {name}!"


if __name__ == "__main__":
    # 打印个环境变量证明环境没问题
    user = os.getenv("USER_NAME", "World")
    print(hello(user))
