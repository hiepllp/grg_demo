(function(w){
  
    var utilMethods = {
        "populateTable":populateTable,
        "round":round,
        "getColor":getColor
    };
    
    function round(value, precision) {
        var multiplier = Math.pow(10, precision || 0);
        var outputHTML = "";

        console.log('value1: ' + value);
        console.log("#####" + Math.round(value * multiplier) / multiplier);
        multiplier = Math.round(value * multiplier) / multiplier;
        return multiplier;
        /*
        if (multiplier <= 25)
        {
           outputHTML = '<div class="score-green">' + multiplier + '</div>';
        }
        else if (multiplier > 25 && multiplier <=75)
        {
          outputHTML = '<div class="score-yellow">' + multiplier + '</div>';
        }
        else if (multiplier > 76)
        {
          outputHTML = '<div class="score-red">' + multiplier + '</div>';
        }
        else
        {
          outputHTML = '<div class="score-grey">' + multiplier + '</div>';
        }
        console.log('outputHTML=' + outputHTML);
        return outputHTML;
        */
    }
    
    function getColor(value,ranges) {
        var pass = 1;
        var color = 'score-grey';
        for (var i=0; i<ranges.length; i++)
        {
            console.log('value='+value+'range='+ranges[i]);
            var tmpStr = ranges[i].split(',');
            var lower = parseInt(tmpStr[0].trim());
            var upper = parseInt(tmpStr[1].trim());
            
            if (pass == 1)
            {
                if (value >= lower && value <= upper )
                {
                    color = 'score-red';
                    break;
                }
            }
            else
            {
                if (value > lower && value <= upper )
                {
                    if (pass == 2) color = 'score-yellow';
                    if (pass == 3) color = 'score-green';
                    break;
                }
            }
            pass++;
        }
        
        return color;
    }
    
    function populateTable(input,params) {
        console.log('initial input: ', input);
   		if (!input || input.length == 0) {
            console.log('input is undefined');
            input = 'No recommendations detected'
        }
        console.log('input: ', input);
        var inputArr = input.split('<br>');
        console.log('inputArr: ', inputArr);
        
        var outputHTML = "";
        
        for (var i = 0; i < inputArr.length; ++i) {
            
            var scoreStr;
            var scoreNum;
            var desc;
            
            var color = '';
            
            // cleans up the strings by removing any system field traits
            var cleanStr = inputArr[i].replace(/%/g,'').replace(/__c/g,'').replace(/_/g,' ').replace('+ ','+').replace('- ','-').trim();
            cleanStr = cleanStr.replace(/\b[a-z]/g,function(f){return f.toUpperCase();})
            console.log("Clean String: " + cleanStr);
            
            // handle format of other smaller phrases
            if(cleanStr.indexOf('other smaller') > 0) {
                scoreStr = cleanStr.substr(0,1) + ' ' + cleanStr.substr(cleanStr.lastIndexOf(' '));
                scoreNum = parseFloat(scoreStr);
                desc = cleanStr.substr(1,cleanStr.lastIndexOf(' '));
                color = getColor(scoreNum,params.ranges);
            }
            else if(cleanStr.startsWith('From The Baseline') > 0){
                scoreStr = cleanStr.split(',')[1].replace('+','+ ').replace('-','- ').replace(' + ','+ ').replace(' - ','- ');
                scoreNum = parseFloat(scoreStr.replace('+ ','').replace('- ','-'));
                console.log('baseline score: ' + scoreStr);
                desc = cleanStr.split(',')[0]
                color = getColor(scoreNum,params.ranges);
            }
            else {
                scoreStr = cleanStr.substr(0, cleanStr.indexOf(' ')).replace('+','+ ').replace('-','- ');
                scoreNum = parseFloat(scoreStr.replace('+ ','').replace('- ','-'));
                desc = cleanStr.substr(cleanStr.indexOf(' ') + 1).replace('Because','').replace('If You Change','Change');
                color = getColor(scoreNum,params.ranges);
            }
            console.log('score: ' + scoreStr);
            
            /*if(score.startsWith('-')){
                color = 'ac-sdd-text-color--green';
            }*/
            
            if(scoreStr.startsWith('N')){
                outputHTML += '<div class="slds-truncate slds-text-body--regular slds-m-vertical--xx-small slds-text-color--weak" title="'  + desc + '">' + scoreStr + (params.space ? ' ' : '') + params.unit + ' ' + desc + '</div>'
            } else{
            	outputHTML += '<div class="slds-item--label ac-sdd-left-col slds-truncate slds-text-body--regular slds-m-vertical--xx-small ' + color + '">' + scoreStr + (params.space ? ' ' : '') + params.unit + '</div>';
				outputHTML += '<div class="slds-item--detail ac-sdd-right-col slds-truncate slds-text-body--regular slds-m-vertical--xx-small slds-text-color--weak" title="' + desc + '">' + desc + '</div>'
            }
        }
        return outputHTML;
	}

	w.myUtil = utilMethods;
})(window);