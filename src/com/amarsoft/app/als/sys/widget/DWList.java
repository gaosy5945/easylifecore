package com.amarsoft.app.als.sys.widget;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.DataConvert;

/**
 * 类似DWlist的页面
 * @author Administrator
 *
 */
public class DWList {

	private String[][] header;
	private List<BizObject> dataList;
	private String tableId="";
	/**
	 * 
	 * @param header
	 */
	public DWList(String[][] header,List<BizObject> lst){
		this.header=header;
		dataList=lst;
		tableId="table_"+(int)(Math.random()*10000);
	}
	
	public String getHTML() throws JBOException{
		StringBuffer temp=new StringBuffer();
		
		temp.append("<DIV id=Table_Content_0>");
		temp.append("<TABLE id=myiframe0   border=0 cellSpacing=0 cellPadding=0 lockCols='0' origFloatHeight='100' origFloatWidth='800'>");
		temp.append(this.getTHead());
		temp.append(this.getBody(this.dataList));
		temp.append("</TABLE></DIV>");
		
		return temp.toString();
	}
	/**
	 * 获得Table的名称 
	 * @return
	 */
	public String getTableId(){
		return this.tableId;
	}
	/**
	 * 获得标题
	 * @return
	 */
	private  String getTHead(){
		
		StringBuffer temp=new StringBuffer();
//		temp.append("<TABLE id=myiframe0   border=0 cellSpacing=0 cellPadding=0 lockCols='0' origFloatHeight='100' origFloatWidth='800'>");
		temp.append("<THEAD id='"+tableId+"' class=list_topdiv_header>");
		temp.append("<TR>");
		temp.append("<TH>");
		temp.append("<DIV style='nw: true' class='list_gridCell_narrow list_left_border' noWrap>&nbsp;</DIV></TH>");
		for(int i=0;i<this.header.length;i++){
			
			if(this.header[i].length>=3){
				temp.append("<TH "+this.header[i][2]+" >");
			}else{
				temp.append("<TH>");
			}
			temp.append(this.header[i][1]+"</TH>");
		}
		temp.append("</TR></THEAD>");
		return temp.toString();
	}
	
	private String getBody(List<BizObject> lst) throws JBOException{
			StringBuffer temp=new StringBuffer();
			temp.append("<TBODY>");
			int irowNum=1;
			for(BizObject bo:lst){
				if(irowNum%2==0){
					temp.append("<TR style='BACKGROUND-COLOR: #f2f2f2' lightColor='#DEE5CD' origColor='#f2f2f2'>");
				}else{
					temp.append("<TR style='BACKGROUND-COLOR: #fff'  lightColor='#DEE5CD' origColor='#FFF'>");
				}

				temp.append("<TD class=list_all_no><DIV style='nw: true' class=list_gridCell_narrow noWrap>"+irowNum+"</DIV></TD>");
				for(int i=0;i<this.header.length;i++){
					String colName=this.header[i][0];
					int iType=bo.getAttribute(colName).getType();
					String style="";
					if(this.header[i].length>=3){
						style=this.header[i][2];
					}
					if(iType==DataElement.DOUBLE){
						temp.append("<TD class=list_all_td "+style+"> &nbsp;"+DataConvert.toMoney(bo.getAttribute(colName).getDouble())+"</TD>"); 
					}else if(iType==DataElement.INT){
						temp.append("<TD class=list_all_td "+style+"> &nbsp;"+ bo.getAttribute(colName).getInt()+"</TD>"); 
					}else{
						temp.append("<TD class=list_all_td "+style+"> &nbsp;"+DataConvert.toRealString(bo.getAttribute(colName).getString())+"</TD>");
					}
				}
				temp.append("</TR>");
				irowNum++;
			}
			temp.append("</TBODY>");
			return temp.toString();

	}
}
