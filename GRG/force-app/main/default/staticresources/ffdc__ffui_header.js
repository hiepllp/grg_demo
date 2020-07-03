/* global $FFUI */
(function(global, namespace, cmpName) {
    var ns = (global[namespace] = global[namespace] || {});

    /**
     * Extends the $FFUI.lightningOutComponent base class. Constructor to use when
     * creating instance of the Header control on your VF page.
     *
     * @param {Object} config object with references to the following: to a loading indicator to destroy upon component render
     * @example     *
     *  window.ffui_header = new $FFUI.header({
     *      loadingIndicator: document.getElementById('ffui_header-loadingIndicator'),
     *      renderTo: 'ffui_headerContainer',
     *  });
     */

    ns[cmpName] = $FFUI.lightningOutComponent.extend(
        function Constructor(cfg) {
            //call the constructor for the base class
            $FFUI.lightningOutComponent.apply(this, arguments);
            this.loadingIndicator = cfg.loadingIndicator;
            this.namespace = cfg.namespace;
            this.config = null;
            this.buttons = null;
            this.fields = null;
        },
        {
            /**
             * function to create render the header with given configuration
             *
             * @param {Object} cfg configuration for header component. See /components/ffui_header for more information about potential attributes
             * @param {Element} indicatorRef (Optional) Reference to loading indicator that you wish to hide when header component is rendered
             */
            renderHeader: function(cfg) {
                var me = this,
                    componentPrefix = me.namespace || 'c';

                //populate instance variables
                me.config = cfg;
                me.buttons = me.config.buttons;
                me.fields = me.config.fields;

                //create components
                me.render(
                    componentPrefix + ':ffui_headerWrapper',
                    me.config,
                    function(cmpRef) {
                        cmpRef.addEventHandler('action', onHeaderEvent);

                        me.hideLoadingIndicator();
                        me.executeOnRenderCallback();
                    }
                );
            },

            /**
             * hides header loading indicator
             */
            hideLoadingIndicator: function() {
                if (this.loadingIndicator) {
                    this.loadingIndicator.style.display = 'none';
                }
            },

            /**
             * if specified, execute `onRender` callback.
             */
            executeOnRenderCallback: function() {
                var callback = this.config.onRender;

                if ('function' === typeof callback) {
                    callback();
                } else if ('string' === typeof callback) {
                    executeFn(callback);
                }
            },

            /**
             * use this to grab cached config for a specific header button
             * @param {*} buttonId id of button you want to examin
             * @returns {Object} button config reference
             */
            getButtonById: function(buttonId) {
                var button = this.buttons.find(function(btn) {
                    return btn.id === buttonId;
                });

                if (!button) {
                    /* eslint no-console: "off" */
                    console.error('unable to find button with id: ' + buttonId);
                }

                return button;
            },

            /**
             * private function used this to rerender header after changing button attributes
             */
            updateButtons: function() {
                this.setAttribute('buttons', this.buttons || []);
            },

            /**
             * change the label for an existing button
             * @param {String} buttonId button you want to modify
             * @param {String} newLabel new button label value
             */
            setButtonLabel: function(buttonId, newLabel) {
                this.modifyButton(buttonId, {
                    label: newLabel
                });
            },

            /**
             * enable specified button
             * @param {String} buttonId
             */
            enableButton: function(buttonId) {
                this.setButtonEnabled(buttonId, true);
            },
            /**
             * disable specified button
             * @param {String} buttonId
             */
            disableButton: function(buttonId) {
                this.setButtonEnabled(buttonId, false);
            },

            /**
             * change button's enabled attribute
             * @param {String} buttonId selected button id
             * @param {Boolean} enabled whether button should be enabled or disabled
             */
            setButtonEnabled: function(buttonId, enabled) {
                this.modifyButton(buttonId, {
                    disabled: !enabled
                });
            },

            /**
             * Modify button attributes in bulk by specifying whatever new attributes you wish to modify. Only specified keys' values will change.
             *
             * @example
             * //given a the following function call
             * ffui_header.getButtonById('saveBtn');
             * // returns
             * {
             *     id: 'saveBtn',
             *     disabled: false,
             *     actionFn: 'doSaveAction'
             * }
             *
             * //after the following function call
             * ffui_header.modifyButton('saveBtn', {
             *     disabled: true
             * });
             *
             * //the follollowing function call
             * ffui_header.getButtonById('saveBtn');
             * // returns
             * {
             *     id: 'saveBtn',
             *     disabled: true,
             *     actionFn: 'doSaveAction'
             * }
             *
             * @param {String} buttonId
             * @param {Object} newConfig
             * @param {Boolean} skipUpdate [skipUpdate=false] used to delay the rerender of all buttons until all necessary changes have been made
             */
            modifyButton: function(buttonId, newConfig, skipUpdate) {
                var button = this.getButtonById(buttonId);

                if (button) {
                    button = Object.assign(button, newConfig);

                    if (!skipUpdate) {
                        this.updateButtons();
                    }
                }
            },

            /**
             * Used to modify multiple existing button attributes in a single rerender:
             * @example
             * //modify two different buttons with two different values
             * ffui_header.modifyButtons({
             *     saveBtn: {
             *         enabled: false
             *     },
             *     deleteBtn: {
             *         enabled: true
             *     }
             * });
             *
             * @param {Object} newConfigMap
             */
            modifyButtons: function(newConfigMap) {
                var buttonIds = Object.getOwnPropertyNames(newConfigMap);

                buttonIds.forEach(function(buttonId) {
                    this.modifyButton(buttonId, newConfigMap[buttonId], true);
                }, this);

                this.updateButtons();
            },

            /**
             * Control the state of the filter button. When true, button has a blue 'brand' color, indicating filter is visible. When false, the button is a grey 'neutral' variant, indicating the filter is not visible
             * @param {Boolean} newVal
             */
            setFilterVisible: function(newVal) {
                this.setAttribute('filterVisible', newVal);
            }
        }
    );

    /**
     * header event handler, used to execute functions on the window scope.
     * @param {ffui_headerEvent} event used to
     */
    function onHeaderEvent(event) {
        var actionFn = event.getParam('actionFn'),
            payload = event.getParam('payload');

        executeFn(actionFn, payload);
    }

    /**
     * Used to execute a function by name from window context
     * @param {String} fnName name of function to execute, including namespace, for example 'someNamespace.someObject.someFunction'
     * @param {...*} args [args] any nunber of arguments for the function call,
     * @example
     * // calls window.namepspace.functionName(arg1, arg2);
     * executeFn('namespace.functionName', 'arg1', 'arg2');`
     */
    function executeFn(fnName /*, args*/) {
        var args = Array.prototype.slice.call(arguments, 1), //arguments after context
            namespaces = fnName.split('.'),
            context = window,
            i;

        try {
            //iterate through the namespaces till you find the object containing the function you wish to execute
            for (i = 0; i < namespaces.length - 1; i++) {
                context = context[namespaces[i]];
            }

            //use function.apply to call the function from the correct context
            return context[namespaces[i]].apply(context, args);
        } catch (error) {
            throw '' + fnName + ' is not a valid function: ' + error;
        }
    }
})(this, '$FFUI', 'header');
