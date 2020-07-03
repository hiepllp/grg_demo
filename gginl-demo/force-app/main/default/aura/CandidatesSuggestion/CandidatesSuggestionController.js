({
    init: function (cmp, event, helper) {
         cmp.set('v.mycolumns', [
             { label: 'First Name', fieldName: 'candidateFirstName', type: 'text'},
             { label: 'Last Name', fieldName: 'candidateLastName', type: 'text'},
             { label: 'Skills Matched', fieldName: 'skillNamesMatchedStr', type: 'text'},
             { label: ' ', fieldName: 'urlView', type: 'url', typeAttributes: {
                label: 'View'
            }},
         ]);
         helper.getData(cmp);
     }
     
 })