var compareArrays, __ko_queue__, __ko_registry__;
__ko_registry__ = {};
__ko_queue__ = {};
ko.extenders.publish = function(target, key) {
    var queued, _i, _len, _ref;
    if (__ko_registry__[key]) {
        throw "Only one observable registry is allowed per key.";
    }
    __ko_registry__[key] = target;
    _ref = __ko_queue__[key] || [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        queued = _ref[_i];
        ko.extenders.subscribe(queued, key);
    }
    delete __ko_queue__[key];
    return target;
};
ko.extenders.subscribe = function(target, key) {
    var isArray, published;
    published = __ko_registry__[key];
    if (!published) {
        (__ko_queue__[key] || (__ko_queue__[key] = [])).push(target);
        return target;
    }
    isArray = published() && published.hasOwnProperty("indexOf");
    published.subscribe(function(newValue) {
        if (isArray) {
            if (!compareArrays(target(), newValue)) {
                return target(newValue.slice(0));
            }
        } else {
            if (target() !== newValue) {
                return target(newValue);
            }
        }
    });
    if (isArray) {
        if (published().length !== 0) {
            target(published().slice(0));
        }
    } else {
        if (published() && target() !== published()) {
            target(published());
        }
    }
    return target;
};
compareArrays = function(list1, list2) {
    var element, i, _len;
    if (list1 === list2) {
        return true;
    }
    if ((!list1 && list2) || (list1 && !list2)) {
        return false;
    }
    if (list1.length !== list2.length) {
        return false;
    }
    if (list1.length === 0 && list2.length === 0) {
        return true;
    }
    for (i = 0, _len = list2.length; i < _len; i++) {
        element = list2[i];
        if (list1[i] !== element) {
            return false;
        }
    }
    return true;
};