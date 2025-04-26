def map_object(obj1, obj2: dict):
    for key, value in obj2.items():
        setattr(obj1, key, value)