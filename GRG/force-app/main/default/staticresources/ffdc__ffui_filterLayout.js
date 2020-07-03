(function(global, namespace, cmpName) {
    var ns = (global[namespace] = global[namespace] || {}),
        proto = Constructor.prototype;

    ns[cmpName] = Constructor;

    function Constructor(cfg) {
        this.headerInstance = cfg.headerInstance;
        this.filterEl = cfg.filterEl;
        this.filterVisible = cfg.filterVisibleOnLoad;
        this.instanceName = cfg.instanceName;

        if (this.headerInstance) {
            this.headerInstance.setAttribute('showFilterButton', true);
            this.headerInstance.setAttribute(
                'filterVisible',
                this.filterVisible
            );
            this.headerInstance.setAttribute(
                'filterToggleAction',
                '' + this.instanceName + '.toggle'
            );
        }

        if (this.filterVisible) {
            this.open();
        }
    }

    /**
     * show/hide the filter component
     * @param {Boolean} makeVisible true to force show the filter component
     */
    proto.toggle = function(makeVisible) {
        //when called by header, makeVisible is not defined because the header does not own the toggle state.
        this.filterVisible =
            typeof makeVisible === 'undefined'
                ? !this.filterVisible
                : makeVisible;

        this.filterEl.classList[this.filterVisible ? 'add' : 'remove'](
            'slds-is-open'
        );
        this.filterEl.classList[this.filterVisible ? 'remove' : 'add'](
            'slds-is-closed'
        );

        if (this.headerInstance) {
            this.headerInstance.setFilterVisible(this.filterVisible);
        }
    };

    /**
     * Show the filter section
     */
    proto.open = function() {
        this.toggle(true);
    };

    /**
     * Hide the filter section
     */
    proto.close = function() {
        this.toggle(false);
    };

    proto.ensureVisibility = function() {
        this.refreshFilterReference();
        if (this.filterVisible) {
            this.filterEl.classList.add('slds-is-open');
            this.filterEl.classList.remove('slds-is-closed');
        }
    };

    proto.refreshFilterReference = function() {
        this.filterEl = document.querySelector('.ffui-filter');
    };
})(this, '$FFUI', 'filterLayout');
