/* global $FFUI */
(function(global, namespace, cmpName) {
    var setAttributeQueue = {};

    /**
     * used to execute queued setAttribute calls for the specified lightningOutComponent instance
     * @param {Object} loCmp reference to `this` lightning out component wrapper instance, not an Aura Component/LWC
     */
    function setAttributeFromQueue(loCmp) {
        var setAttrQueue = setAttributeQueue[loCmp],
            attrConfig;

        if (!setAttrQueue) {
            return;
        }

        while (setAttrQueue.length) {
            attrConfig = setAttrQueue.shift();
            loCmp.setAttribute(attrConfig.attrName, attrConfig.attrValue);
        }

        delete setAttributeQueue[loCmp];
    }

    /**
     * private variable used to queue setAttribute calls for unrendered lightning out component instances.
     * @param {Object} loCmp unrendered lightning out component wrapper instance
     * @param {Object} request setAttribute request to execute when lightning out component is rendered
     */
    function queueSetAttrRequest(loCmp, request) {
        if (!setAttributeQueue[loCmp]) {
            setAttributeQueue[loCmp] = [];
        }

        setAttributeQueue[loCmp].push(request);
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

    namespace = global[namespace] = global[namespace] || {};

    if (!$FFUI || !$FFUI.base) {
        throw 'ffui_lightningOutComponent: static resource "ffui_base" is a dependency and must be loaded for this library to work properly.';
    }

    namespace[cmpName] = $FFUI.base.extend(
        function Constructor(cfg) {
            this.renderTo = cfg.renderTo; // DOM id
            this.cmp = null;
        },
        {
            /**
             * public function to set attributes on the header component. When be called before component is rendered,
             * the execution will be delayed until the component is rendered.
             *
             * @param {String} attrName name of attribute to change
             * @param {*} attrValue new value for attribute on the header
             */
            setAttribute: function(attrName, attrValue) {
                var me = this,
                    cmp = me.cmp;

                if (!cmp) {
                    // if the component is not yet rendered, we queue the request and execute it as soon as the componet is rendered
                    queueSetAttrRequest(this, {
                        attrName: attrName,
                        attrValue: attrValue
                    });
                } else if (cmp.isValid()) {
                    /**
                     * As far as I can tell, when we pass a reference to the same Object[] that was originally
                     * used to render the LWC, the LWC does not pick up deep changes inside the objects, and
                     * will not rerender the LWC even if the object has been modified.
                     *
                     * So, I'm using this JSON.parse/stringify hack to deep clone all objects and ensure that
                     * we rerender LWC whenever a change is made. the side effect is that some rerenders may
                     * not be necessary so we will have to evaluate this for production
                     */
                    if (typeof attrValue === 'object') {
                        attrValue = JSON.parse(JSON.stringify(attrValue));
                    }

                    /**
                     * Use $A.getCallback() to wrap any code that modifies a component outside the normal
                     * rerendering lifecycle, such as in a setTimeout() call. The $A.getCallback() call
                     * ensures that the framework rerenders the modified component and processes any
                     * enqueued actions.
                     */
                    setTimeout(
                        $A.getCallback(function() {
                            if (cmp.isValid()) {
                                cmp.set('v.' + attrName, attrValue);
                            }
                        }),
                        10
                    );
                } else {
                    /* eslint no-console: "off" */
                    console.error('component is not valid: ', cmp);
                }
            },

            /**
             *
             * @param {String } descriptor name of aura component to render.e.g. `c:ffui_modalDialog``asfdad`
             * @param {Object} cfg attribute values to pass to the component
             * @param {Function(cmpReferenc)} callback accepting a reference to the rendered lightning component. a good place to add event listeners
             *
             * @example
             *  instancereference.render(
             *      'c:someLightningComponent',
             *      {
             *          someLightningComponent: 'foo'
             *      },
             *      function (cmp) {
             *          cmp.addEventHandler('onClose', $A.getCallback(function (event) {
             *              var dialog = event.getSource();
             *              dialog.hide();
             *          }));
             *          cmp.show();
             *      });
             *  );
             */
            render: function(descriptor, cfg, callback) {
                var me = this;

                /**
                 * Create component with instance of $FFUI.lightningOut.
                 * See component vf component: `ffui_lighningOut.component`
                 * and static resource `ffui_lightningOut.js`
                 */
                $FFUI.out.createComponent(
                    descriptor,
                    cfg,
                    me.renderTo,
                    function(cmpRef) {
                        me.cmp = cmpRef;

                        setAttributeFromQueue(me);

                        fn(callback, [cmpRef]);
                    }
                );
            },

            destroy: function() {
                if (this.cmp) {
                    this.cmp.destroy();
                    delete this.cmp;
                }
            }
        }
    );
})(this, '$FFUI', 'lightningOutComponent');
