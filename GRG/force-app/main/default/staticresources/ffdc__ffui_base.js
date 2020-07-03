/*
 * Copyright (c) 2019 FinancialForce.com, inc. All rights reserved.
 */
(function(global, namespace, cmpName) {
    var statics = {
            extend: extendClass
        },
        BaseClass;

    function bind(Class, name, fn) {
        Object.defineProperty(Class, name, {
            value: fn.bind(Class)
        });
    }

    function applyStatics(Class) {
        for (var name in statics) {
            bind(Class, name, statics[name]);
        }
    }

    function defineClass(Class, config) {
        var proto = Class.prototype;

        //assign config properties to prototype
        for (var prop in config) {
            proto[prop] = config[prop];
        }

        return Class;
    }

    /**
     * Public Static method used to create extensions of this class.
     * @param {Function} Class constructor of the dervied class
     * @param {Object} config object containing instance variables you wish to be on your derived class' prototype
     */
    function extendClass(Class, config) {
        Class.prototype = Object.create(this.prototype);
        Class.prototype.constructor = Class;

        applyStatics(Class);

        return defineClass(Class, config);
    }

    namespace = global[namespace] = global[namespace] || {};

    BaseClass = namespace[cmpName] = defineClass(function Constructor() {});

    //Export static variable `extend` on the BaseClass;
    applyStatics(BaseClass);
})(this, '$FFUI', 'base');
