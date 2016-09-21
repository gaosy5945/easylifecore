package com.amarsoft.app.als.sys.widget;

import java.util.List;
/**
 * Ê÷Í¼ÐÎÊ½
 * @author Administrator
 *
 */
public class TreeTable {
	
	private String name="";
	private String value="";
	private List<TreeTable>  childList;
	public String tableId="";
	private String[][] iheader;
	private String treeTableName;
	
	public   TreeTable(String[][] header){ 
		this.iheader=header;
		tableId="treeTable"+(int)(Math.random()*10000);
	}
	
	public String getHtml(){
		StringBuffer temp=new StringBuffer();
		temp.append("<table class='"+tableId+"'>");
	 	temp.append("<thead>");
		temp.append("<tr>");
		for(int i=0;i<iheader.length;i++){
			temp.append("<th name='"+iheader[i][0]+"'>"+iheader[i][1]+"</th>");
		}
		
		temp.append("</tr></thead><tbody>");
		int ipar=0;
		for(int j=0;j<100;j++){
			String scls="child-of-";
			if(j%10==0){
					scls="";
					ipar=j;
			}else{
				scls+=""+ipar;
			}
			temp.append("<tr id='"+j+"' class='"+scls+"' nodeData=''>");
			for(int i=0;i<iheader.length;i++){
				temp.append("<td name='"+iheader[i][0]+"'>"+i+"</td>");
			}
			temp.append("</tr>");
		}
	 	temp.append("</tbody></table>");
		return temp.toString();
	}

	public String getTreeTableName() {
		return treeTableName;
	}

	public void setTreeTableName(String treeTableName) {
		this.treeTableName = treeTableName;
	}
	
	 

}
