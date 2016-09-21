var ProductSpecificInfo={};

$(document).ready(function(){
	var specificID=getItemValue(0,0,"SPECIFICID");
	if(specificID=="000"){
		setItemDisabled(0,0,"SPECIFICID",true);
	}
});