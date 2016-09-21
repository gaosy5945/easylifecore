<%@page import="com.amarsoft.biz.classify.*,com.amarsoft.app.lending.bizlets.InitializeFlow" %> 
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content: 该页面主要对五级分类的流程进行初始化操作。
	*/
	//定义变量
	int iTCount = 0;
    String sSql = "",sCustomerID = "",sSerialNo = "";
    double dBalance = 0.0;
    ASResultSet rs = null; //存放查询结果集
	
	//获取页面参数
	String sObjectType   = CurPage.getParameter("ObjectType"); //"Classify"
	String sObjectNo     = CurPage.getParameter("ObjectNo"); //借据或合同号
	String sAccountMonth = CurPage.getParameter("AccountMonth");
	String sModelNo      = CurPage.getParameter("ModelNo");
	String sResultType 	 = CurPage.getParameter("ResultType"); //五级分类借据或合同	
	String sType 		 = CurPage.getParameter("Type");	
	//将空值转化为空字符串	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sResultType == null) sResultType = "";
	if(sType == null) sType = "";
	
	//根据对象类型设置其表名
    String sTableName = "";
    if(sResultType.equals("BusinessContract")){
        sTableName = "BUSINESS_CONTRACT";
    }
    if(sResultType.equals("BusinessDueBill")){
        sTableName = "BUSINESS_DUEBILL";
    }
    
    try{
        //如果是批量分类,则不初始化流程
		if(sType.equals("Batch")){
        	//目前针对批量五级分类新增只是预留，不能用流程来实现五级分类批量申请。
            sSql =  " select SerialNo,nvl(Balance,0) as Balance,CustomerID "+
                    " from "+sTableName+" "+
                    " where not exists (select 1 from CLASSIFY_RECORD "+
                    " where ObjectType = '"+sResultType+"' and AccountMonth = '"+sAccountMonth+"' and ObjectNo="+sTableName+".SerialNo) "+
                    " and Balance > 0 ";
            rs = Sqlca.getASResultSet(sSql);
            while(rs.next()){
                sObjectNo = rs.getString("SerialNo");
                dBalance = rs.getDouble("Balance");
                sCustomerID = rs.getString("CustomerID");
                //在CLASSIFY_RECORD表中新增记录
                sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca);
                sSql = " update CLASSIFY_RECORD set CustomerID = '" + sCustomerID + "', " +
                       " BusinessBalance = " + dBalance + ", " +
                       " InputDate = '"+StringFunction.getToday()+"', "+
                       " UpdateDate = '"+StringFunction.getToday()+"' "+
                       " where SerialNo = '"+sSerialNo+"' ";
                Sqlca.executeSQL(sSql);
            }
            rs.getStatement().close();          
        }else{
            //查询合同/借据的余额，初始化流程
            sSql =  " select count(SerialNo) from CLASSIFY_RECORD "+
                    " where ObjectType = '"+sResultType+"' and ObjectNo = '"+sObjectNo+"' and AccountMonth = '"+sAccountMonth+"' ";
            rs = Sqlca.getASResultSet(sSql);
            if (rs.next())
            	iTCount = rs.getInt(1);
            rs.getStatement().close();        
            if(iTCount > 0){
            	out.println("IsExist"); //AJAX返回值
            }else{
	            //如下逻辑针对AmarGCI4.0版本已经把BUSINESS_DUEBILL表中的CUSTOMERID字段赋值，因此在BUSINESS_DUEBILL表中可以取到CUSTOMERID
	            //如果不是用最新版本的AmarGCI，取CUSTOMERID的方法请自己添加 add by cbsu 2009-10-14
	            sSql =  " select Balance,CustomerID from "+sTableName+" where SerialNo = '"+sObjectNo+"' ";                   
	            rs = Sqlca.getASResultSet(sSql);
	            if(rs.next()){
	                dBalance = rs.getDouble("Balance");
	                sCustomerID = rs.getString("CustomerID");
	            }    
	            rs.getStatement().close();
	            //在CLASSIFY_RECORD表中新增记录
	            sSql = "select SerialNo from classify_record where ObjectType='"+sResultType+"' and ObjectNo='"+sObjectNo+"' and AccountMonth='"+sAccountMonth+"'";
	            sSerialNo = Sqlca.getString(sSql);
	            if(sSerialNo == null || sSerialNo.length() == 0){
	            	sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca);
	            }else{
	            	//批量已将此数据插入到CLASSIFY_RECORD,因此不用再插入了。
	            	//但是CLASSIFY_DATA批量不会插入此数据，因此需要插入
		        		sSql = "insert into CLASSIFY_DATA ( ObjectType,ObjectNo,SerialNo,ItemNo) " 
		    					+" select '" + sObjectType + "','" + sObjectNo + "','" + sSerialNo + "',"
		            			+" ItemNo from EVALUATE_MODEL where ModelNo = '" + sModelNo + "'";
	            	Sqlca.executeSQL(sSql);
	            }
	            sSql = " update CLASSIFY_RECORD set CustomerID = '" + sCustomerID + "', " +
	                   " BusinessBalance = " + dBalance + ", " +
	                   " InputDate = '"+StringFunction.getToday()+"', "+
	                   " UpdateDate = '"+StringFunction.getToday()+"' "+
	                   " where SerialNo = '"+sSerialNo+"' ";
	            Sqlca.executeSQL(sSql);
	            //初始化五级分类流程
	            InitializeFlow InitializeFlow_Classify = new InitializeFlow();
	            InitializeFlow_Classify.setAttribute("ObjectType",sObjectType);
	            InitializeFlow_Classify.setAttribute("ObjectNo",sSerialNo); 
	            InitializeFlow_Classify.setAttribute("ApplyType","ClassifyApply");
	            InitializeFlow_Classify.setAttribute("FlowNo","ClassifyFlow");
	            InitializeFlow_Classify.setAttribute("PhaseNo","0010");
	            InitializeFlow_Classify.setAttribute("UserID",CurUser.getUserID());
	            InitializeFlow_Classify.setAttribute("OrgID",CurUser.getOrgID());
	            InitializeFlow_Classify.run(Sqlca);
            }
        }
		out.println(sSerialNo); //AJAX返回值
    }catch(Exception e){
        throw new Exception("事务处理失败！"+e.getMessage());
    }       
%><%@ include file="/IncludeEndAJAX.jsp"%>