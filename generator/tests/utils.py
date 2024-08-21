import os


def set_env(name, value, prefix="RDWV_"):
    os.environ[f"{prefix}{name}"] = value


def delete_env(name, prefix="RDWV_"):
    del os.environ[f"{prefix}{name}"]


def check_service_list(config, expected, is_none=False):
    for service in expected:
        if is_none:
            assert service not in config["services"]
        else:
            assert service in config["services"]
