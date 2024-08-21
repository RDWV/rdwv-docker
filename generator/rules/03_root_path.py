from os.path import join as urljoin

from generator.utils import modify_key


def rule(services, settings):
    if not settings.ONE_DOMAIN_MODE:
        return
    API_URL = urljoin(settings.API_URL, "api")
    STORE_AVAILABLE = services.get("store")
    ADMIN_AVAILABLE = services.get("admin")
    BACKEND_AVAILABLE = services.get("backend")
    # replace defaults
    if STORE_AVAILABLE:
        with modify_key(services, "store", "environment") as environment:
            environment["RDWV_STORE_API_URL"] = API_URL
        if ADMIN_AVAILABLE:
            with modify_key(services, "admin", "environment") as environment:
                environment["RDWV_ADMIN_ROOTPATH"] = environment["RDWV_ADMIN_ROOTPATH"].replace("/", "/admin")
                environment["RDWV_ADMIN_API_URL"] = API_URL
                environment["RDWV_STORE_HOST"] = settings.HOST or ""
            with modify_key(services, "store", "environment") as environment:
                environment["RDWV_ADMIN_HOST"] = urljoin(settings.HOST or "", "admin")
                environment["RDWV_ADMIN_ROOTPATH"] = environment["RDWV_ADMIN_ROOTPATH"].replace("/", "/admin")
    elif ADMIN_AVAILABLE:
        with modify_key(services, "admin", "environment") as environment:
            environment["RDWV_ADMIN_API_URL"] = API_URL
    if BACKEND_AVAILABLE and (ADMIN_AVAILABLE or STORE_AVAILABLE):
        with modify_key(services, "backend", "environment") as environment:
            environment["RDWV_BACKEND_ROOTPATH"] = environment["RDWV_BACKEND_ROOTPATH"].replace("-}", "-/api}")
    if BACKEND_AVAILABLE and ADMIN_AVAILABLE:
        with modify_key(services, "backend", "environment") as environment:
            if STORE_AVAILABLE:
                environment["RDWV_ADMIN_HOST"] = urljoin(settings.HOST or "", "admin")
                environment["RDWV_ADMIN_ROOTPATH"] = environment["RDWV_ADMIN_ROOTPATH"].replace("/", "/admin")
            else:
                environment["RDWV_ADMIN_HOST"] = settings.HOST or ""
