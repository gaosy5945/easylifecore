package com.amarsoft.app.util;

import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;

/**
 * ����������������
 * @author wmZhu
 * @date 2014-5-19
 */
public class ReturnReferTableUtil {
	private String[][] header;
	private String[][] dataArray;
	private String tableId="";
	/**
	 * 
	 * @param header
	 */
	public ReturnReferTableUtil(String[][] header,String[][] data){
		this.header=header;
		dataArray=data;
		tableId="table_"+(int)(Math.random()*10000);
	}
	
	public String getHTML() throws JBOException{
		StringBuffer temp=new StringBuffer();
		
		temp.append("<DIV id=Table_Content_0>");
		temp.append("<TABLE id=myiframe0 align='center'  border=0 cellSpacing=0 cellPadding=0 lockCols='0' origFloatHeight='100' origFloatWidth='800'>");
		temp.append(this.getTHead());
		temp.append(this.getBody(dataArray));
		temp.append("</TABLE></DIV>");
		
		return temp.toString();
	}
	/**
	 * ���Table������ 
	 * @return
	 */
	public String getTableId(){
		return this.tableId;
	}
	/**
	 * ��ñ���
	 * @return
	 */
	private  String getTHead(){
		
		StringBuffer temp=new StringBuffer();
		temp.append("<THEAD id='"+tableId+"' class=list_topdiv_header>");
		temp.append("<TR>");
		for(int i=0;i<this.header.length;i++){
			temp.append("<TH "+this.header[i][1]+" >");
			temp.append(this.header[i][0]+"</TH>");
		}
		temp.append("</TR></THEAD>");
		return temp.toString();
	}
	
	private String getBody(String[][] arrays) throws JBOException{
			double refundSum = 0.0;//�����ܼ�
			double corpusSum = 0.0;//�����ܼ�
			double interestSum = 0.0;//��Ϣ�ܼ�
			StringBuffer temp=new StringBuffer();
			temp.append("<TBODY>");
			int irowNum=1;
			for(int i=0;i<=arrays.length;i++){
				if(irowNum%2==0){
					temp.append("<TR style='BACKGROUND-COLOR: #f2f2f2' lightColor='#DEE5CD' origColor='#f2f2f2'>");
				}else{
					temp.append("<TR style='BACKGROUND-COLOR: #fff'  lightColor='#DEE5CD' origColor='#FFF'>");
				}
				if(i == arrays.length){
					temp.append("<TD class=list_all_td "+this.header[0][1]+" align='center'> &nbsp;�ϼ�</TD>");
					temp.append("<TD class=list_all_td "+this.header[1][1]+" align='center'> &nbsp;</TD>");
					temp.append("<TD class=list_all_td "+this.header[2][1]+" align='center'> &nbsp;"+DataConvert.toMoney(refundSum)+"</TD>");
					temp.append("<TD class=list_all_td "+this.header[3][1]+" align='center'> &nbsp;"+DataConvert.toMoney(corpusSum)+"</TD>");
					temp.append("<TD class=list_all_td "+this.header[4][1]+" align='center'> &nbsp;"+DataConvert.toMoney(interestSum)+"</TD>");
				}else{
					String[] tempValue = arrays[i];
					for(int j=0;j<tempValue.length;j++){
						if(!StringX.isEmpty(tempValue[j])){
							if(j==2) refundSum += Double.parseDouble(tempValue[j]);//�����ܼ�
							else if(j==3) corpusSum += Double.parseDouble(tempValue[j]);//�����ܼ�
							else if(j==4) interestSum += Double.parseDouble(tempValue[j]);//��Ϣ�ܼ�
							tempValue[j] = DataConvert.toMoney(tempValue[j]);
						}
						temp.append("<TD class=list_all_td "+this.header[j][1]+" align='center'> &nbsp;"+tempValue[j]+"</TD>");
					}
				}
				temp.append("</TR>");
				irowNum++;
			}
			temp.append("</TBODY>");
			return temp.toString();

	}
}
