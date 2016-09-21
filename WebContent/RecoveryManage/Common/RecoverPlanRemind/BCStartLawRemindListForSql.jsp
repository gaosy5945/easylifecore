<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	String sSql = "";
	ASResultSet rs = null;
	SqlObject so = null;
	StringBuffer sENName = new StringBuffer();
	StringBuffer sCHName = new StringBuffer();
	
	try{
	   	sSql =  " select dl.colname as ENName,dl.colheader as CHName from awe_do_library dl where dono='BCStartLawRemindList' order by sortno";
	 	so = new SqlObject(sSql);
	   	rs = Sqlca.getASResultSet(so);    	  	
	   	while(rs.next())
		 {
	   		sENName.append(DataConvert.toString(rs.getString("ENName"))).append(",");
	   		sCHName.append(DataConvert.toString(rs.getString("CHName"))).append(",");
		}
		rs.getStatement().close();
	}catch(Exception e){
		e.fillInStackTrace();
	}
 	String [] header = sCHName.toString().substring(0, sCHName.toString().length()-1).split(",");
 	String[] headers = {"标题1","标题2","标题3","标题4"};
 	//ASObjectModel doTemp = new ASObjectModel(headers);
 	ASObjectModel doTemp = new ASObjectModel(header);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.setPageSize(20);
	String[][] displayData = new String[20][4];
	int lCount = 0;

 	String [] sENHeader = sENName.toString().substring(0, sENName.toString().length()-1).split(",");
	try{
		sSql =  " select count(serialno) as cnt from business_contract O where  O.CONTRACTSTATUS ='03' and ((O.Maturitydate>=to_char(add_months(sysdate,-24),'yyyy/mm/dd') and O.Maturitydate<=to_char(sysdate,'yyyy/mm/dd')) or ( O.Maturitydate<to_char(sysdate,'yyyy/mm/dd') and O.Maturitydate>to_char(add_months(sysdate,-1),'yyyy/mm/dd'))) and not exists (select 1 from lawcase_relative lr where lr.objectno=O.serialno ) ";
	 	so = new SqlObject(sSql);
	   	rs = Sqlca.getASResultSet(so);    	  	
	   	if(rs.next())
		 {
	   		lCount = rs.getInt("cnt");
		}
		rs.getStatement().close();
	}catch(Exception e){
		e.fillInStackTrace();
	}	
	lCount = 100;
	String sValues [][]  = new String [lCount][header.length];
	try{
	   	sSql =  " select O.* from business_contract O where  O.CONTRACTSTATUS ='03' and ((O.Maturitydate>=to_char(add_months(sysdate,-24),'yyyy/mm/dd') and O.Maturitydate<=to_char(sysdate,'yyyy/mm/dd')) or ( O.Maturitydate<to_char(sysdate,'yyyy/mm/dd') and O.Maturitydate>to_char(add_months(sysdate,-1),'yyyy/mm/dd'))) and not exists (select 1 from lawcase_relative lr where lr.objectno=O.serialno ) ";
	 	so = new SqlObject(sSql);
	   	rs = Sqlca.getASResultSet(so); 
	   	int j = 0;
	   	while(rs.next()&&j<=lCount)
		 {
	   		for(int i=0;i<sENHeader.length;i++){
	   			sValues [j][i] =  DataConvert.toString(rs.getString(sENHeader[i]));
	   		}
	   		j++;
		}
		rs.getStatement().close();
	}catch(Exception e){
		e.fillInStackTrace();
	}
	dwTemp.genHTMLObjectWindow(sValues); 
	/* 
	for(int i=0;i<displayData.length;i++){
		for(int j=0;j<displayData[i].length;j++){
			displayData[i][j]= "数据" + i + "," + (j+1);
		}
	}
	dwTemp.genHTMLObjectWindow(displayData); */
	String sButtons[][] = {};
%><%@ include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
