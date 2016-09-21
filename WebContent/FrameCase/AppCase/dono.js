(function($) {
  var options = {};
  var defaultPaddingLeft=null;
  $.fn.doinfo = function(opts,doData) {
	  var donoInfo=[];
	  var defaults = {
	            childPrefix: "child-of-",
	            clickableNodeNames: false,
	            expandable: true,
	            indent: 19,
	            initialState: "collapsed",
	            treeColumn: 0
	          };
	  options = $.extend(defaults, opts);  //应用参数
	  donoInfo=doData["info"];
	  data=doData["data"][0];
	  $(this).html("");

	  var table=$("<table></table>").appendTo(this);
	  var tr;
	  var inum=0;
	  for(var o in donoInfo){
		   if(inum%2==0){
			   tr=$("<tr></tr>").appendTo(table);
		   }
		   inum++;
		  var do_data=donoInfo[o];
		  var colIndex=do_data["colIndex"];
		  var colEditType=do_data["ColEditStyle"];
		  var colEditSource=do_data["colEditSource"];
		  var colName=do_data["colname"];
		  var colReadOnly=do_data["colReadOnly"];
		  colName=colName.toUpperCase();
		  var colDefaultValue=data[colName];
		  if(colDefaultValue==null||typeof(colDefaultValue)=="undefined"){
			  colDefaultValue="";
		  }
		  var td=$("<td colName='"+colName+"'></td>").appendTo(tr);
		  $("<lable>"+do_data["colHeader"]+"<lable>").appendTo(td); 
		  var tdValue= $("<td></td>").appendTo(tr);
		  this.getEditType(colIndex,colEditType,colEditSource,tdValue,colDefaultValue,data,colReadOnly);
	  }
	 
	  
  };
  
  $.fn.getEditType=function(colIndex,colEditType,colEditSource,tdObj,colDefaultValue,data,colReadOnly){
	  if(colEditType=="Radiobox") this.radio(colIndex,colEditSource,tdObj,colDefaultValue,data,colReadOnly);
	  else if(colEditType=="Select") this.select(colIndex,colEditSource,tdObj,colDefaultValue,data,colReadOnly);
	  else if(colEditType=="Textarea") this.textArea(colIndex,tdObj,colDefaultValue,data,colReadOnly);		  
	  else this.text(colIndex,tdObj,colDefaultValue,data,colReadOnly);
  };
  /**radio形式*/
  $.fn.radio=function(colIndex,colEditSource,tdObj,colDefaultValue,data,colReadOnly){
		var readOnly="";
  	    if(colReadOnly == 1)    	readOnly = "disabled=true";
	  for(var o in colEditSource){
		  var value=o;
		  var text=colEditSource[o];
		 $("<input type='radio' value='"+value+"' name='"+colIndex+"' "+(colDefaultValue==value?"checked":"")  + readOnly+"/>").appendTo(tdObj).change(function(){
			 changeValue(data,tdObj,$(this).val());
		 });
		 $("<lable>"+text+"</lable>").appendTo(tdObj);
	  }
  };
  $.fn.select=function(colIndex,colEditSource,tdObj,colDefaultValue,data,colReadOnly){
		var readOnly="";
  	    if(colReadOnly == 1)
  	    	readOnly = "disabled=true";
	  var select=$("<select name='"+colIndex+"'  " + readOnly+"></select>").appendTo(tdObj).change(function(){
		  data[tdObj.prev().attr("colname")] = $(this).val();
	  });
	  for(var o in colEditSource){
		  var value=o;
		  var text=colEditSource[o];
		 $("<option  value='"+value+"' "+(colDefaultValue==value?"selected":"")+">"+text+"</option>").appendTo(select);
	  }
  };
  /**文本框形式*/
  $.fn.text=function(colIndex,tdObj,colDefaultValue,data,colReadOnly){ 
  		var readOnly = "";
  	    if(colReadOnly == 1)
  	    	readOnly = "disabled=true";
	   $("<input type='text' value='"+colDefaultValue+"' name='"+colIndex+"'  " + readOnly+"/>").appendTo(tdObj).change(function(){
		   data[tdObj.prev().attr("colname")] = $(this).val();
	   });
  };
  /**文本框形式*/
  $.fn.textArea=function(colIndex,tdObj,colDefaultValue,data,colReadOnly){ 
		var readOnly = "";
  	    if(colReadOnly == 1)
  	    	readOnly = "disabled=true";
  	  $("<textarea  name='"+colIndex+"'  " + readOnly+">"+colDefaultValue+"</textarea>").appendTo(tdObj).change(function(){
  		  data[tdObj.prev().attr("colname")] = $(this).val();
  	  });
  };

  function changeValue(data,tdObj,value){ 
	  data[tdObj.prev().attr("colname")] = value;
  }
  
}
)(jQuery);