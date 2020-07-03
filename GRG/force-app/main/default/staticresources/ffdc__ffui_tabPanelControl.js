/* global $FFUI */
(function(global, namespace, cmpName) {
    if (!$FFUI || !$FFUI.base) {
        throw 'ffui_lightningOutComponent: static resource "ffui_base" is a dependency and must be loaded for this library to work properly.';
    }

    var ns = (global[namespace] = global[namespace] || {}),
        constants = {
            PARENT_ID_SUFFIX: '_tabPanel',
            SHOW_NEXT_INCREMENT: 1,
            SHOW_PREV_INCREMENT: -1,
            ARROW_RIGHT: 'ArrowRight',
            ARROW_LEFT: 'ArrowLeft',
            ROLE_PRESENTATION: 'presentation',
            ROLE_TAB: 'tab',
            SLDS_IS_ACTIVE: 'slds-is-active',
            SLDS_SHOW: 'slds-show',
            SLDS_HIDE: 'slds-hide',
            ARIA_SELECTED: 'aria-selected',
            ARIA_CONTROLS: 'aria-controls',
            LOADING: 'loading',
            ID: 'id',
            TABINDEX: 'tabindex',
            DATA_NAME: 'data-name',
            ROLE: 'role',
            HREF: 'href',
            ITEM_ID_SUFFIX: '__item',
            ANCHOR_CLASS: 'slds-tabs_default__link',
            LIST_ITEM_CLASS: 'slds-tabs_default__item',
            JS_VOID: 'javascript:void(0);',
            TITLE: 'title',
            DOM_CONTENT_LOADED: 'DOMContentLoaded',
            KEYDOWN: 'keydown',
            CLICK: 'click',
            FOCUS: 'focus',
            BLUR: 'blur',
            TRUE: 'true',
            LI: 'li',
            A: 'a',
            ADD: 'add',
            REMOVE: 'remove',
            TAB_ACTION_FOCUS: 'onFocus',
            TAB_ACTION_BLUR: 'onBlur'
        };

    ns[cmpName] = $FFUI.base.extend(
        function Constructor(parentId) {
            var me = this;

            me.tabMap = null;
            me.names = null;
            me.activeName = null;
            me.activeIdx = null;
            me.parentEl = null;

            if (document.readyState === constants.LOADING) {
                // Loading hasn't finished yet
                document.addEventListener(
                    constants.DOM_CONTENT_LOADED,
                    function() {
                        registerTabControl(me, parentId);
                    }
                );
            } else {
                // `DOMContentLoaded` has already fired
                registerTabControl(me, parentId);
            }
        },
        {
            onTabLinkClick: function(el) {
                var name = el.getAttribute(constants.DATA_NAME);

                this.activateTabByName(name);
            },

            getActiveName: function() {
                return this.names[this.activeIdx];
            },

            getActiveTabInfo: function() {
                return this.getTabInfoByName(this.getActiveName());
            },

            getTabInfoByName: function(name) {
                return this.tabMap[name];
            },

            getTabInfoByLinkEl: function(linkEl) {
                return this.getTabInfoByName(linkEl.dataset.name);
            },

            activateTabByName: function(name) {
                this.selectTabInfo(this.getTabInfoByName(name));
            },

            activateTabByIdx: function(idx) {
                var name = this.names[idx];
                this.activateTabByName(name);
            },

            selectTabInfo: function(tabInfo) {
                if (this.getActiveName() === tabInfo.name) {
                    return;
                }

                this.hideActiveTab();

                this.activeName = tabInfo.name;
                this.activeIdx = this.names.indexOf(this.activeName);

                setTabLinkSelected(tabInfo.link, true);
                setTabItemSelected(tabInfo.tab, true);
            },

            hideActiveTab: function() {
                var tabInfo = this.getActiveTabInfo();

                if (tabInfo) {
                    setTabLinkSelected(tabInfo.link, false);
                    setTabItemSelected(tabInfo.tab, false);
                }
            },

            // When we focus on tab link, we want to start listening to arrow keys for keyboard navigation
            onTabLinkFocus: function(el) {
                var me = this;

                //keep named reference for removal, use closure for scope
                me.boundOnKeyDown = function(evt) {
                    me.onKeyDown(evt);
                };

                el.addEventListener(constants.KEYDOWN, me.boundOnKeyDown);

                this.runTabAction(el, constants.TAB_ACTION_FOCUS);
            },

            onTabLinkBlur: function(el) {
                // Must manually remove listener because we cannot use `once` option on the listener
                el.removeEventListener(constants.KEYDOWN, this.boundOnKeyDown);

                this.runTabAction(el, constants.TAB_ACTION_BLUR);
            },

            onKeyDown: function(evt) {
                if (evt.key === constants.ARROW_RIGHT) {
                    this.incrementActiveTab(constants.SHOW_NEXT_INCREMENT);
                } else if (evt.key === constants.ARROW_LEFT) {
                    this.incrementActiveTab(constants.SHOW_PREV_INCREMENT);
                }
            },

            /**
             * Used to show next or previous
             * @param {Number} increment, expected values are `1` to show next, and `-1` to show previous
             */
            incrementActiveTab: function(increment) {
                var me = this,
                    nextName = me.names[me.activeIdx + increment],
                    nextTabInfo;

                if (nextName) {
                    nextTabInfo = me.getTabInfoByName(nextName);
                    me.selectTabInfo(nextTabInfo);
                    focusOnTabInfo(nextTabInfo);
                }
            },

            runTabAction: function(linkEl, actionName) {
                var fnName = this.getTabInfoByLinkEl(linkEl).tab.dataset[
                    actionName
                ];

                if (typeof fnName === 'string') {
                    executeFn(fnName);
                }
            }
        }
    );

    function createTabListItem(config) {
        var me = this,
            name = config.name,
            label = config.label,
            active = config.active,
            li = document.createElement(constants.LI),
            innerEl = document.createElement(constants.A);

        li.classList.add(constants.LIST_ITEM_CLASS);
        li.setAttribute(constants.TITLE, label);
        li.setAttribute(constants.ROLE, constants.ROLE_PRESENTATION);

        if (active) {
            li.classList.add(constants.SLDS_IS_ACTIVE);
        }

        innerEl.classList.add(constants.ANCHOR_CLASS);
        innerEl.setAttribute(constants.HREF, constants.JS_VOID);
        innerEl.setAttribute(constants.ROLE, constants.ROLE_TAB);
        innerEl.setAttribute(constants.DATA_NAME, name);
        innerEl.setAttribute(constants.TABINDEX, active ? 0 : -1);
        innerEl.setAttribute(constants.ARIA_SELECTED, active);
        innerEl.setAttribute(constants.ARIA_CONTROLS, name);
        innerEl.setAttribute(constants.ID, getLinkIdByName(name));
        innerEl.innerText = label;

        innerEl.addEventListener(constants.CLICK, function() {
            me.onTabLinkClick(innerEl);
        });
        innerEl.addEventListener(constants.FOCUS, function() {
            me.onTabLinkFocus(innerEl);
        });
        innerEl.addEventListener(constants.BLUR, function() {
            me.onTabLinkBlur(innerEl);
        });

        li.appendChild(innerEl);

        return li;
    }

    function getInfoFromTabEl(tabEl) {
        var atts = tabEl.dataset;

        return {
            name: atts.name,
            label: atts.label,
            active: atts.active === constants.TRUE //convert string to Boolean
        };
    }

    function registerTabControl(instance, parentId) {
        var parentEl = (instance.parentEl = document.getElementById(
                parentId + constants.PARENT_ID_SUFFIX
            )),
            children = Array.prototype.slice.call(parentEl.children),
            ulEl = children[0], // <ul> element which will contain the link list items
            lTab = children.slice(1),
            lLinkInfo = lTab.map(getInfoFromTabEl),
            lListItem = lLinkInfo.map(createTabListItem.bind(instance)),
            names = (instance.names = []),
            tabMap = (instance.tabMap = {});

        lLinkInfo.forEach(function(info, idx) {
            var name = info.name;

            names.push(name);

            if (info.active) {
                instance.activeIdx = idx;
                instance.activeName = name;
            }

            tabMap[name] = {
                name: name,
                link: lListItem[idx].children[0],
                tab: lTab[idx]
            };
        });

        ensureAtLeastOneActiveTab(instance);

        lListItem.forEach(function(el) {
            ulEl.appendChild(el);
        });
    }

    function ensureAtLeastOneActiveTab(instance) {
        if (instance.activeIdx === null || !instance.activeName) {
            instance.activateTabByIdx(0);
        }
    }

    function setTabLinkSelected(controlEl, selected) {
        controlEl.setAttribute(constants.ARIA_SELECTED, !!selected);
        controlEl.setAttribute(constants.TABINDEX, selected ? 0 : -1);
        controlEl.parentElement.classList[
            selected ? constants.ADD : constants.REMOVE
        ](constants.SLDS_IS_ACTIVE);
    }

    function setTabItemSelected(itemEl, selected) {
        itemEl.classList[selected ? constants.REMOVE : constants.ADD](
            constants.SLDS_HIDE
        );
        itemEl.classList[selected ? constants.ADD : constants.REMOVE](
            constants.SLDS_SHOW
        );
    }

    function focusOnTabInfo(tabInfo) {
        if (tabInfo.link) {
            tabInfo.link.focus();
        }
    }

    function getLinkIdByName(name) {
        return '' + name + constants.ITEM_ID_SUFFIX;
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
            return null;
        }
    }
})(this, '$FFUI', 'tabPanelControl');
