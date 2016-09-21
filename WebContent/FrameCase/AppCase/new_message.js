function newMessage(userId) { 
	  this.userId=userId;
	 this.mainDiv;
	 this.divBtn;
	 this.msg;
	 this.lstBtn;
	 this.nextBtn;
	 this.messageArray=[];
	 this.icurArray=0;
	 this.numDiv;
	 this.queryTime=1000;
	 this.IntervalObj;
	 this.checkOut=false;
	 this.boradMessage=function(){
		param="ToUserID="+ this.userId+"&action=get";
		if(this.checkOut) return [];
		var sReturn=AsControl.RunJsp("/AppConfig/BoardManage/MessageActionAJAX.jsp",param); 
		if(typeof(sReturn)=="undefined" || sReturn.length==0) return [];
		if(sReturn.indexOf("非法访问")>0) {
			 this.checkOut=true;
			return [];
		}
		 messageArray=eval(sReturn); 
		return messageArray;
	}; 
	this.showMessage=function(msgDiv,messageArray,icur){
		if(icur<0 || icur==messageArray.length){
			$(msgDiv).html("<br>没有了["+icur+"]");
			return "";
		}
		var message;
		message=messageArray[icur];
		if(typeof(message)=="undefined"){
			$(msgDiv).html("<br>没有了["+icur+"]");
			return "";
		}
		var  msg=message["fromUser"]+":"+message["inputTime"]+":</br>"+message["message"]+"</br>";
		$(this.numDiv).html((icur+1)+"/"+messageArray.length);
		$(msgDiv).html(msg);
	    return msg;
	}; 
	this.writeTipsDiv=function(){
	   	 obj=this;  
		 this.mainDiv=$("<div id='msg_main' class='msg_main_div'>").appendTo(document.body);
		 this.msg=$("<div class='msg_div tree_show_in_view'></div>").appendTo(this.mainDiv);
		 this.divBtn=$("<div class='msg_title'></div>").appendTo(this.mainDiv);
		 this.lstBtn=$("<a class='lastLab'>忽略</a>").appendTo(this.divBtn).click(function(){
			 obj.mainDiv.hide();
		 }); 
		 this.numDiv=$("<a class='msg_num'></a>").appendTo(this.divBtn)
		 this.nextBtn=$("<a class='nextLab'>查看全部</a>").appendTo(this.divBtn).click(function(){
			$("<div class='msg_all'>信息</div>").appendTo(document.body);
		 }); 
		 if(this.messageArray.length>0){ 
			 for(var inum=0;inum<this.messageArray.length;inum++){
				 var curMessage=this.messageArray[inum];
				 $("<a>"+curMessage["fromUser"]+":"+curMessage["message"]+"<br></a>").appendTo(this.msg);
			 }
		 };
		this.mainDiv.slideToggle(1000);
		return "1";
   	}; 
   	this.start=function(){
		 this.query();
  	};
  	
  	this.query=function(){ 
  		this.messageArray=this.boradMessage();
		if(this.messageArray.length<=0) return; 
		this.writeTipsDiv();
 	};
 	
   	
}; 