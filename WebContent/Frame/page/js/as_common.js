









function substringAfter( str1,  str2) { 
   if(typeof(str1)=="undefined") return "";
   var index = str1.indexOf(str2);
   if(index==-1) return "";
   return str1.substring(index+str2.length);
} 






function substringBefore( str1,  str2) { 
   if(typeof(str1)=="undefined") return "";
   var index = str1.indexOf(str2);
   if(index==-1) return "";
   return str1.substring(0,index);
} 






function charLength(str) {
    if( str == null || str ==  "" ) return 0;
    var totalCount = 0;
    for (var i = 0; i< str.length; i++) {
        if (str.charCodeAt(i) > 127) 
            totalCount += 2;
        else
            totalCount++ ;
    }
    return totalCount;
}






function containsNOASC( s) {
    if( s == null || s ==  "" ) return false;
    for (var i = 0; i< s.length; i++) {
        if (s.charCodeAt(i) > 127) 
             return true;
    }
    return false;
}






function lTrim(str){
	var i = 0;
	while(str.charCodeAt(i) <=32 ){
	    ++i;
	}
	str = str.substring(i);
	return str;
}






function rTrim(str){
	var i = str.length-1;
	while(str.charCodeAt(i) <=32){
		--i;
    }
	str = str.substring(0,i+1);
	return str;
}






function trim(str){
	return lTrim(rTrim(str));
}






function allTrim(str){
	return str.replace(/\s/g,"");
}





function conversion(str){
	var newstr="";
	for(var i=0;i<str.length;i++){
		switch(str.charAt(i)){
		case '<':
		    newstr=newstr+"&lt;";
			break;
		case ">":
            newstr=newstr+"&gt;";
            break;
		case "&":
            newstr=newstr+"&amp;";
			break;
		case " ":
            newstr=newstr+"&nbsp;";
			break;
		default:
		newstr=newstr+str.charAt(i);
		break;
		}
	}
	return newstr;
}






function substringBetween(sSource, str1,  str2) { 
   var stringAfter = substringAfter(sSource,str1);
   var stringBetween = substringBefore(stringAfter,str2);
   return stringBetween;
}

function parseReturnXML(sSource,segment,sVariable){
	if(typeof(sSource)=="undefined") return "";
	//alert(1+"\n"+sSource+" \n"+segment+"\n"+sVariable);
	var segString = substringBetween(sSource,"<"+segment+">","</"+segment+">");
	if(segString==""){
		return "";
	}else if(sVariable==null || sVariable==""){
		return segString;
	}else{
		return substringBetween(segString,"<"+sVariable+">","</"+sVariable+">").trim();
	}
}

function getSegment(inStr,separator,segment){
	var elementItems = inStr.split(separator);
	for(var i=0;i<elementItems.length;i++){
		if(segment-1==i) return elementItems[i];
	}
	return "";
}

function getProfileString(inStr,keyStr){
	inStr = inStr.toString();
	if(inStr==null || typeof(inStr)=="undefined"){
		alert("缺少输入字符串");
	}
	if(inStr.length<=0){
		return "";
	}
	var valueItems = new Array();
	valueItems = inStr.split(";");
	for(var i=0;i<valueItems.length;i++){
		var itemKey=getSegment(valueItems[i],"=",1);
		if(itemKey==keyStr)
			return getSegment(valueItems[i],"=",2);
	}
	return "";
}

function toNumber(str){
	if(str)
		str = str.replace(/\,/g,"");
	if(isNaN(str))
		return 0;
	else
		return parseFloat(str);
}




function getSplitArray(str, delim){
	if(!str) return "";
	if(delim==null || typeof(delim)=="undefined"){
		delim = "@";
	}
	return str.split(delim);
}







function isNull(obj){
	if(obj == null || typeof(obj) == "undefined"){
		return true;
	}
	if(obj == "" || obj.length <= 0){
		return true;
	}
	return false;
}



jQuery.extend({
	objectKeyArray:new Array(),//存储快捷键和对象
	//运行
	runByKey: function(code,isShift,isCtrl,isAlt) {
		//判断数组中的快捷键是否一致，如果一直则运行run方法
		for(var i = 0;i<jQuery.objectKeyArray.length;i++){
			var objectKey = jQuery.objectKeyArray[i];
			try{
				if(objectKey[0]==code && objectKey[1]==isShift
						&& objectKey[2]==isCtrl
						&& objectKey[3]==isAlt
				){
					objectKey[4].click();
					break;
				}
			}
			catch(e){alert("快捷键绑定出错了：" + e.message);}
		}
	},
	getKeyCode : function(char){//根据字符获得键值
		char = char.toUpperCase();
		if(char=='F1') return 112;
		if(char=='F2') return 113;
		if(char=='F3') return 114;
		if(char=='F4') return 115;
		if(char=='F5') return 116;
		if(char=='F6') return 117;
		if(char=='F7') return 118;
		if(char=='F8') return 119;
		if(char=='F9') return 120;
		if(char=='F10') return 121;
		if(char=='F11') return 122;
		if(char=='F12') return 123;
		
		if(char=='DEL' || char=='DELETE') return 46;
		
		if(char=='0') return 48;
		if(char=='1') return 49;
		if(char=='2') return 50;
		if(char=='3') return 51;
		if(char=='4') return 52;
		if(char=='5') return 53;
		if(char=='6') return 54;
		if(char=='7') return 55;
		if(char=='8') return 56;
		if(char=='9') return 57;
		
		if(char=='A') return 65;
		if(char=='B') return 66;
		if(char=='C') return 67;
		if(char=='D') return 68;
		if(char=='E') return 69;
		if(char=='F') return 70;
		if(char=='G') return 71;
		if(char=='H') return 72;
		if(char=='I') return 73;
		if(char=='J') return 74;
		if(char=='K') return 75;
		if(char=='L') return 76;
		if(char=='M') return 77;
		if(char=='N') return 78;
		if(char=='O') return 79;
		if(char=='P') return 80;
		if(char=='Q') return 81;
		if(char=='R') return 82;
		if(char=='S') return 83;
		if(char=='T') return 84;
		if(char=='U') return 85;
		if(char=='V') return 86;
		if(char=='W') return 87;
		if(char=='X') return 88;
		if(char=='Y') return 89;
		if(char=='Z') return 90;
	},
	initObjectKeyArray : function(){//初始化关键字对象数组
		$("span[dw_quickkey]").each(function(i){	
			var key = this.getAttribute("dw_quickkey");//获得对象的快捷键
			//alert(key);
			if(key){
				var aKeys = key.split("+");//复合关键字通过+分隔，所以，这里需要拆分
				
				var isShift = false;
				var isCtrl = false;
				var isAlt = false;
				var code = 0;
				
				for(var i=0;i<aKeys.length;i++){
					if(aKeys[i]=="Shift")
						isShift = true;
					else if(aKeys[i]=="Ctrl")
						isCtrl = true;
					else if(aKeys[i]=="Alt")
						isAlt = true;
					else{
						code = jQuery.getKeyCode(aKeys[i]);
					}
				}
				//保存操作
				var tmp = new Array(5);
				tmp[0] = code;
				tmp[1] = isShift;
				tmp[2] = isCtrl;
				tmp[3] = isAlt;
				tmp[4] = this;
				jQuery.objectKeyArray[jQuery.objectKeyArray.length] = tmp;
			}
		 }); 
		//alert(jQuery.objectKeyArray);
	}
});















