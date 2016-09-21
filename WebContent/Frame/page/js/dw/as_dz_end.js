function getTrueLength(mystr){
	var cArr = mystr.match(/[^x00-xff]/ig);
	return mystr.length+(cArr==null?0:cArr.length);
}

function getLeft(mystr,leftLen){
	var mylen=mystr.length;
	var realNum=0;
	for(var i=1;i<=mylen;i++){
		if(mystr.charCodeAt(i-1)<0||mystr.charCodeAt(i-1)>255)
			realNum++;
		if(i+realNum==leftLen) break;
		if(i+realNum>leftLen) {i--; break; }
	}
	return mystr.substring(0,i);
}

function textareaMaxByIndex(iDW,iRow,iCol){ 
	var obj=getASObjectByIndex(iDW,iRow,iCol); 
	var maxlimit=DZ[iDW][1][iCol][7]; 
	if(maxlimit==0) return; 
	if(getTrueLength(obj.value) > maxlimit){
		obj.value = getLeft(obj.value, maxlimit); 
	}
} 

function textareaMax(iDW,iRow,sCol){
	iCol = getColIndex(iDW,sCol); 
	textareaMaxByIndex(iDW,iRow,iCol); 
}





try{
	document.frames["myiframe0"].document.body.oncontextmenu='self.event.returnValue=true';
}catch(e){}

AsOne.SetDefault("");