/**
 * Javascript Library or SupercashMatching.page
 *
 * All functions are namespaced with the FF. Make sure you understand the DOM before making changes. In particular pay
 * attention to the way the table rows are constructed.
 */

 var FF = {
	/**
	 * Variable to hold the Static resource Path
	 */
	 resourcePath: String(),

	/**
	 * Setup function called on page load
	 */
	 setup: function(resourcePath)
	 {
	 	jQuery('#tabs').tabs();
		// Assign the static resource path
		FF.resourcePath = resourcePath;

		// create the error dialog
		jQuery('#errordialog').dialog({
			autoOpen: false,
			modal: true
		});

		//this turns off the modal
		jQuery('dialog[id^="dialog-box"]').dialog( "close" );
		jQuery('dialog[id^="displaybox"]').dialog( "close" );

		// Remove exiting change events on the Account, Product and Orderline Lookups
		// to prevent mutliple event issues in Firefox issues.
		jQuery('input[id$="account-lkwgt"]').off('change');
		
		// Enable the ffa dashbaords setup Button
		jQuery('button[id^="btn-removetab-"]').button({ disabled: false });

		// Enable the update depreciation method Button
		jQuery('button[id^="btn-chain-"]').button({ disabled: false });
		
		// Enable the Cancel Button
		jQuery('button[id^="btn-cancel-"]').button({ disabled: false });

		// Enable the Rebuild Apex Button
		jQuery('button[id^="btn-rebuildapex-"]').button({ disabled: false });

		// Enable the Rebuild Apex Button
		jQuery('button[id^="btn-careersite-"]').button({ disabled: false });

		// Enable the Rebuild Apex Button
		jQuery('button[id^="btn-licenseExtension-"]').button({ disabled: false });

		// Enable the Rebuild Apex Button
		jQuery('button[id^="btn-quickedit-"]').button({ disabled: false });

		// Apply the jQuery UI Accordion widget to the matching selection div
		jQuery('#commission-run-selection').accordion({
			collapsible: true,
			activate: function( event, ui ) { FF.resizeTransactions(); }
		});	

		// Apply the jQuery UI Accordion widget to the recent batches div
		jQuery('#recent-batches-view').accordion({
			collapsible: true,
			activate: function( event, ui ) { FF.resizeTransactions(); }
		});	


		// Apply the jQuery UI Accordion widget to the balances div
		jQuery('#balances').accordion({
			collapsible: true,
			activate: function( event, ui ) { FF.resizeTransactions(); }
		});			

		// // Wire up UI events
		FF.wireUpUIEvents();

		// // wireup window resize
		jQuery(window).on('resize', function(event) {
			FF.resizeTransactions();
		});
	},
	/**
	 * Wire up all the Core UI events, such as button clicks and form changes
	 */
	 wireUpUIEvents: function()
	 {
	 	FF.wireUpBtnRebuildApex();
	 	FF.wireUpBtnCancelClick();
	 	FF.wireUpChain1();
	 	FF.wireUpRemoveTab();
	 	FF.wireUpLicenseExtension();
	 	FF.wireUpCareerSite();
	 },

	/**
	 * Generic confirm dialog box
	 *
	 * Arguments: 	message		The prompt to present to the user
	 *				onConfirm	The function to call on a positive response
	 */

	 confirmDialog: function(message)
	 {
	 	var html = '<p>' + message + '</p>';

	 	jQuery('#dialog-message').html(html);

	 	jQuery('#dialog-box').dialog({
	 		modal: true,
	 		buttons: {
	 			OK: function() {
	 				jQuery(this).dialog( "close" );
	 			},
	 		}
	 	});
	 },

	 wireUpRemoveTab: function()
	 {
	 	jQuery('button[id^="btn-removetab-"]').on('click', function(event) 
	 	{
	 		FF.RemoveDialog('Press OK to hide this tab from your user.')
	 	});
	 },

	 startdialogue: function()
	 {
	 	jQuery('#loading').css('display','block');
	 	jQuery('#loadingtext').css('display','block');

	 },

	 finishdialogue: function()
	 {
	 	jQuery('#loading').css('display','none');
	 	jQuery('#loadingtext').css('display','none');
	 },

	 RemoveDialog: function(message)
	 {
	 	var html = '<p>' + message + '</p>';

	 	jQuery('#dialog-message').html(html);

	 	jQuery('#dialog-box').dialog({
	 		modal: true,
	 		buttons: {
	 			'OK': function() {
	 				FF.Removetab();
	 				jQuery(this).dialog( "close" );
	 			},
	 			'Cancel': function() {
	 				jQuery(this).dialog( "close" );
	 			},
	 		}
	 	});
	 },

	 Chain1Dialog: function(message)
	 {
	 	var html = '<p>' + message + '</p>';

	 	jQuery('#dialog-message').html(html);

	 	jQuery('#dialog-box').dialog({
	 		modal: true,
	 		buttons: {
	 			'OK': function() {
	 				FF.Chain1();
	 				jQuery(this).dialog( "close" );
	 			},
	 			'Cancel': function() {
	 				jQuery(this).dialog( "close" );
	 			},
	 		}
	 	});
	 },

	 wireUpChain1: function()
	 {
	 	jQuery('button[id^="btn-chain-"]').on('click', function(event) 
	 	{
	 		FF.Chain1Dialog('This process will: <ul><li>Enable Communities</li> <li>Fix the Projects and RPGs</li> <li>Fix Actuals</li><li>Update the contact, Bill Lumbergh</li><li>Update the depreciation methods</li><li>Run a Reporting Balance Update</li><li> Fix the Account Drill down</li><li>Purge and Rebuild Tax and Currency Exchange</li><li>Update the Source Id field of all action view related objects.</li><li>Correctly configure all action view related objects.</li><li>Populate the Company Logo for printing documents.</li></ul><p>You can monitor the progess of batches below.</p>')
	 	});
	 },

	 RebuildApexDialog: function(message)
	 {
	 	var html = '<p>' + message + '</p>';

	 	jQuery('#dialog-message').html(html);

	 	jQuery('#dialog-box').dialog({
	 		modal: true,
	 		buttons: {
	 			'Open': function() {
	 				window.open("/01p");
	 			},
	 			'Cancel': function() {
	 				jQuery(this).dialog( "close" );
	 			},
	 		}
	 	});
	 },

	 wireUpBtnRebuildApex: function()
	 {
	 	jQuery('button[id^="btn-rebuildapex-"]').on('click', function(event) 
	 	{
	 		FF.RebuildApexDialog('When all batches have finished, you must press the following button in the next window. <p style="text-align:center"><img src="/resource/MDOSetupImages/compileAllClasses.png" ></p>')

	 	});
	 },

	 CareerSiteSetup: function(message)
	 {
	 	var html = '<p>' + message + '</p>';

	 	jQuery('#dialog-message').html(html);

	 	jQuery('#dialog-box').dialog({
	 		modal: true,
	 		buttons: {
	 			'Open': function() {
	 				window.open("/udd/Site/customSubdomain.apexp");
	 			},
	 			'Cancel': function() {
	 				jQuery(this).dialog( "close" );
	 			},
	 		}
	 	});
	 },

	 wireUpCareerSite: function()
	 {
	 	jQuery('button[id^="btn-careersite-"]').on('click', function(event) 
	 	{
	 		FF.CareerSiteSetup('<p>If you plan on using the FinancialForce HCM External Career Site, then this must be configured.</p><p>In the next window you must mark that you have read and accepted the Force.com Sites Terms of Use, followed by the Register button.</p><img style="height:150px" src="/resource/MDOSetupImages/CareerSiteActivate.png" ><p>The site will then be accessible from the Site URL listed.</p><img style="height:120px" src="/resource/MDOSetupImages/CareerSiteURL.png" >')

	 	});
	 },

	 wireUpLicenseExtension: function()
	 {
	 	jQuery('button[id^="btn-licenseExtension-"]').on('click', function(event) 
	 	{
	 		FF.LicenseExtension('<p> Select from the options below depending on which license you would like to extend.</p>')

	 	});
	 },

	 LicenseExtension: function(message)
	 {
	 	var html = '<p>' + message + '</p>';

	 	jQuery('#dialog-message').html(html);

	 	jQuery('#dialog-box').dialog({
	 		modal: true,
	 		buttons: {
	 			'FinancialForce': function() {
	 				FF.FFLicenseExtension('<p>This action will email licensing (subscription@financialforce.com) with details of your org and a request to extend the license dates by one year.</p><p>You will be copied into this email.</p><p><b>Note</b> that you will still need to create a case with Salesforce to extend your salesforce license.</p>')
	 			},
	 			'Salesforce': function() {
	 				FF.SFLicenseExtension('<p>To extend your Salesforce license you must: <li>Copy your org id. Setup > Company Information</li><li>Log into the Salesforce Partner Portal https://partners.salesforce.com</li><li>Log a case with Salesforce asking them to extend your org.</li></p>')
	 			},
	 			'Conga': function() {
	 				FF.CongaLicenseExtension('<p><b>IMPORTANT</b> If you are using Conga you must firstly activate your Conga account before it can be extended: <li>Access <a href="/0A3" target="_blank">installed packages</a>.</li><li>Scroll and select Configure next to the Conga Composer package. </li><li>Press the <b>Create Salesforce Token</b> button within the offline access section.</li></p><p>Only once this is done can you use the button below for an email request to extend your Conga license. You will be copied into this email.</p>')
	 			},

	 		}
	 	});
},

SFLicenseExtension: function(message)
{
	Visualforce.remoting.timeout = 120000;      
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.googleCalendar',
		function(result, event)
		{
                if (event.status)	// success
                {
                	var html = '<p>' + message + '</p><a href="' + result + '" target="_blank">Add to Calendar</a>';
                }

                jQuery('#dialog-message').html(html);

                jQuery('#dialog-box').dialog({
                	modal: true,
                	buttons: {
                		'Remind me later': function() {
                			FF.extendSFLicense();
                			jQuery(this).dialog( "close" );
                		},
                		'Close': function() {
                			jQuery(this).dialog( "close" );
                		},
                	}
                });
            },
            {escape: true}
            );
},


Standard: function(message)
{
	var html = '<p>' + message + '</p>';

	jQuery('#dialog-message').html(html);

	jQuery('#dialog-box').dialog({
		modal: true,
		buttons: {
			'Close': function() {
				jQuery(this).dialog( "close" );
			},

		}
	});
},

CongaLicenseExtension: function(message)
{
	var html = '<p>' + message + '</p>';

	jQuery('#dialog-message').html(html);

	jQuery('#dialog-box').dialog({
		modal: true,
		buttons: {
			'Email': function() {
				FF.extendCongaLicense();
				jQuery(this).dialog( "close" );
			},
		}
	});
},


FFLicenseExtension: function(message)
{
	var html = '<p>' + message + '</p>';

	jQuery('#dialog-message').html(html);

	jQuery('#dialog-box').dialog({
		modal: true,
		buttons: {
			'Email': function() {
				FF.extendFFLicense();
				jQuery(this).dialog( "close" );
			},
		}
	});
},

wireUpBtnCancelClick: function()
{        	
	jQuery('button[id^="btn-cancel-"]').on('click', function(event) {
		window.history.back();
	});
},

Chain1: function()
{
	FF.startdialogue();
	Visualforce.remoting.timeout = 120000;
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.runeverything',
		function(result, event)
		{
                if (event.status)	// success
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Starting...you will be notified by email once the process is complete.</p> <p>You can navigate away from this page or log out if you wish.</p>')
                }
                else				// error
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Process Failed.</p>' + event.message + '<p>Contact mbyrne@financialforce.com</p>')
                }
            },
            {escape: true}
            );
},

Removetab: function()
{
	FF.startdialogue();
	Visualforce.remoting.timeout = 120000;
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.removetab',
		function(result, event)
		{
                if (event.status)	// success
                {
                	FF.finishdialogue();
                	FF.confirmDialog('Success. Refresh or Navigate away to view the change.')
                }
                else				// error
                {
                	FF.confirmDialog('<p>Process Failed.</p>' + event.message + '<p>Contact mbyrne@financialforce.com</p>')
                }
            },
            {escape: true}
            );
},

extendFFLicense: function()
{
	FF.startdialogue();
	Visualforce.remoting.timeout = 120000;      
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.extendFFLicense',
		function(result, event)
		{
                if (event.status)	// success
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Success. An email has been sent to licensing.</p><p>You can check your email to confirm this.</p>')
                }
                else				// error
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Process Failed.</p>' + event.message + '<p>Contact mbyrne@financialforce.com</p>')
                }
            },
            {escape: true}
            );
},

extendCongaLicense: function()
{
	FF.startdialogue();
	Visualforce.remoting.timeout = 120000;      
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.extendCongaLicense',
		function(result, event)
		{
                if (event.status)	// success
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Success. An email has been sent to Conga.</p><p>You can check your email to confirm this.</p>')
                }
                else				// error
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Process Failed.</p>' + event.message + '<p>Contact mbyrne@financialforce.com</p>')
                }
            },
            {escape: true}
            );
},

extendSFLicense: function()
{
	FF.startdialogue();
	Visualforce.remoting.timeout = 120000;      
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.extendSFLicense',
		function(result, event)
		{
                if (event.status)	// success
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>A reminder email has been scheduled for 20 days before org expiry.</p>')
                }
                else				// error
                {
                	FF.finishdialogue();
                	FF.confirmDialog('<p>Process Failed.</p>' + event.message + '<p>Contact mbyrne@financialforce.com</p>')
                }
            },
            {escape: true}
            );
},

RebuildApex: function()
{

	Visualforce.remoting.timeout = 120000;      
	Visualforce.remoting.Manager.invokeAction(
		'MDOScriptsRemote.compileapex',
		function(result, event)
		{
                if (event.status)	// success
                {
                }
                else				// error
                {
                }
            },
            {escape: true}
            );
},

	/**
	 * Wire up the Toggle Icon click to collapse/expand details
	 */
	 wireUpToggleClick: function()
	 {        	
	 	jQuery('.linetype-header .col-toggle').off('click');

	 	jQuery('.linetype-header .col-toggle').on('click', function(event) {
        	// Get the image
        	var image = jQuery(this).find('img');

        	// get the image source
        	var imageSrc = jQuery(image).attr('src');

        	var lastSlash = imageSrc.lastIndexOf('/');

        	// identify the path and file
        	var path = imageSrc.substring(0, lastSlash);
        	var fileName = imageSrc.substring(lastSlash);

        	// if the image is down.png its expanded, so collapse
        	if (fileName == '/down.png')
        	{
        		jQuery(this).parent().nextUntil('.linetype-header').hide();
        		jQuery(image).attr('src', path + '/right.png'); 
        	}
        	else // othwise expand
        	{
        		jQuery(image).attr('src', path + '/down.png'); 
        		jQuery(this).parent().nextUntil('.linetype-header').show();
        	}
        });
	 },
    	/**
	 * Resizes the Transactions to make the most of available screen real estate
	 */
	 resizeTransactions: function()
	 {
	 	var accordion = jQuery('#container .ff-form');

		// if its not rendered, quit
		if (accordion.length == 0)
		{
			return;
		}

		// get the window height
		var windowHeight = jQuery(window).height();

		// get the offset of the content
		var containerTop = jQuery('#container .ff-form .ui-accordion-content').offset().top;

		var containerHeight = windowHeight - containerTop - 30;

		jQuery('#container .ff-form .ui-accordion-content').height(containerHeight);
	},


}