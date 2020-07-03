(function(global, namespace, className) {
    var queues = {
        createComponent: [],
        addHandler: []
    };

    // Class export

    namespace = global[namespace] = global[namespace] || {};
    namespace[className] = Constructor;

    // Class constructor

    function Constructor(outAppName) {
        $Lightning.use(outAppName, function() {
            addHandlerFromQueue();
            createComponentsFromQueue();
        });
    }

    // Class methods
    Object.assign(Constructor.prototype, {
        createComponent: createComponent,
        addHandler: addHandler
    });

    // Public functions

    /**
     * Create a component from type descriptor and set of attributes.
     * @param {String} descriptor The type of component to create, e.g. "ui:button".
     * @param {Object} attributes A map of attributes to send to the component. These take the same form as on the markup, including events.
     * @param {String} renderTo Id of the DOM element where you want the component inserted.
     * @param {Function} callback The method to call, to which it returns the newly created component.
     */
    function createComponent(descriptor, attributes, renderTo, callback) {
        var config = {
            descriptor: descriptor,
            attributes: attributes || {},
            renderTo: renderTo,
            callback: callback
        };

        if (queues.createComponent) {
            queues.createComponent.push(config);
        } else {
            createLightningComponent(config);
        }
    }

    /**
     * Register an application event handler
     * @param {String} event Application event name, e.g. "force:navigateToSObject"
     * @param {Function} handler Event handler function reference
     */
    function addHandler(event, handler) {
        var config = {
            event: event,
            handler: handler
        };

        if (queues.addHandler) {
            queues.addHandler.push(config);
        } else {
            addEventHandler(config);
        }
    }

    // Private functions

    function addEventHandler(config) {
        $A.eventService.addHandler(config);
    }

    function addHandlerFromQueue() {
        while (queues.addHandler.length) {
            addEventHandler(queues.addHandler.pop());
        }
        delete queues.addHandler;
    }

    function createComponentsFromQueue() {
        while (queues.createComponent.length) {
            createLightningComponent(queues.createComponent.pop());
        }
        delete queues.createComponent;
    }

    function createLightningComponent(config) {
        $Lightning.createComponent(
            config.descriptor,
            config.attributes,
            config.renderTo,
            function(cmp) {
                fn(config.callback, [cmp]);
            }
        );
    }

    /**
     * Function executor
     * @param {Function} f Function reference
     * @param {Any[]} a Array of argument values
     * @param {Object} s Scope (value of this)
     */
    function fn(f, a, s) {
        if (typeof f === 'function') {
            if (a && a.length) {
                return f.apply(s, a);
            }
            return f.call(s);
        }
        return false;
    }
})(this, '$FFUI', 'lightningOut');
