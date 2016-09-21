package com.amarsoft.app.als.sys.widget;


public class Wizard {

	private String[][] wizArray;
	private String webRootPath="";
	
	private String defaulClickId="'";
	private boolean directForward=false;
	/**
	 * 向导内容图：
	 *  String[][] wizArray={
			{"010","基础信息","/FrameCase/ExampleInfo.jsp","CustomerID=1","定义产品的基本管理要求"},
			{"020","客户类组件","/FrameCase/ExampleInfo04.jsp","CustomerID=1","定义产品的客户类组件相关要求"},
			{"030","债项类组件","/FrameCase/ExampleInfo03.jsp","CustomerID=1","定义产品的债项类组件相关要求"},
			{"040","作业流程类组件","/FrameCase/UICaseMain.jsp","CustomerID=1","定义产品的作业流程组件相关要求"},
		};
	 * @param wizArray
	 */
	public Wizard(String[][] wizArray,String sWebRootPath ,boolean directForward){
		this.wizArray=wizArray;
		this.webRootPath=sWebRootPath;
		this.defaulClickId=this.wizArray[0][0];
		this.directForward = directForward;
	}
	
	
	public String getHtml(){ 
		StringBuffer temp=new StringBuffer();
		temp.append("<div id='wizTitle'><table class='wiz_tbl' width='100%'><tr class='wiz_tr'><td id='forwardStep' nowrap='nowrap'>");
	
		for(int i=0;i<wizArray.length;i++){
			String url=wizArray[i][2];
			String parameters=wizArray[i][3];
			String wizId=wizArray[i][0];
			String onclick = directForward==true ? " onclick=\"javascript:openMyWiz('"+wizId+"')\" " : "";
			if(i==0)  temp.append("<a  wizTag='true'   class='wiz_normal' " + onclick + " id='"+wizId+"'  lastid='"+wizArray[i][0]+"'   nextid='"+wizArray[i+1][0]+"'  describe='"+wizArray[i][4]+"' url='"+url+"'  param='"+parameters+"' ''>"+wizArray[i][1]+"&nbsp;&nbsp;>&nbsp;&nbsp;</a>");
			else if(i<wizArray.length-1)   temp.append("<a  wizTag='true'  " +onclick + "  class='wiz_normal'   id='"+wizId+"'  lastid='"+wizArray[i-1][0]+"'   nextid='"+wizArray[i+1][0]+"'  describe='"+wizArray[i][4]+"' url='"+url+"'   param='"+parameters+"' >"+wizArray[i][1]+"&nbsp;&nbsp;>&nbsp;&nbsp;</a>");
			else   temp.append("<a wizTag='true'  id='"+wizArray[i][0]+"' " + onclick+ " class='wiz_normal' nextid='"+wizId+"'  lastid='"+wizArray[i-1][0]+"'  describe='"+wizArray[i][4]+"'  url='"+url+"'   param='"+parameters+"'>"+wizArray[i][1]+"</a>");
		}
		temp.append("</td><td id='title_decribe' nowrap='nowrap'></td></tr></table>");
		temp.append("</div>");
		temp.append(this.getContent()); 
		return temp.toString();
	}
	
	
	
	public String getDefaulClickId() {
		return defaulClickId;
	}


	public void setDefaulClickId(String defaulClickId) {
		this.defaulClickId = defaulClickId;
	}


	public String getContent(){
			String str="<div id='wizContent' class='wizContent'>";
			 str+="	<iframe name='wizFrame' width='100%' height='100%' src=\''"+webRootPath+"/AppMain/Blank.html\" frameborder=0></iframe>";
			 str+="	</div> ";
			 return str;
	}
	
	
	/*private String getButtonContent(){
		String str="<hr>";
		 str+="<div id='wizButton' class='wizButton'>";
		 str+=new Button("上一步", "上一步", "openLastWiz()", "", "", "").getHtmlText(); 
		 str+=new Button("下一步", "下一步", "openNextWiz() ", "", "", "").getHtmlText();
		 str+="</div>";
		return str;
	}*/
	
	
}
