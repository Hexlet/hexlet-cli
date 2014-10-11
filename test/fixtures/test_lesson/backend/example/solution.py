import redis

def get(key, r):
    # BEGIN
    return r.get(key)
    # END

def set(key, value, r):
    # BEGIN
    return r.set(key, value)
    # END
