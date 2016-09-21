<%@page import="com.amarsoft.biz.classify.*,com.amarsoft.app.lending.bizlets.InitializeFlow" %> 
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Content: ��ҳ����Ҫ���弶��������̽��г�ʼ��������
	*/
	//�������
	int iTCount = 0;
    String sSql = "",sCustomerID = "",sSerialNo = "";
    double dBalance = 0.0;
    ASResultSet rs = null; //��Ų�ѯ�����
	
	//��ȡҳ�����
	String sObjectType   = CurPage.getParameter("ObjectType"); //"Classify"
	String sObjectNo     = CurPage.getParameter("ObjectNo"); //��ݻ��ͬ��
	String sAccountMonth = CurPage.getParameter("AccountMonth");
	String sModelNo      = CurPage.getParameter("ModelNo");
	String sResultType 	 = CurPage.getParameter("ResultType"); //�弶�����ݻ��ͬ	
	String sType 		 = CurPage.getParameter("Type");	
	//����ֵת��Ϊ���ַ���	
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sResultType == null) sResultType = "";
	if(sType == null) sType = "";
	
	//���ݶ����������������
    String sTableName = "";
    if(sResultType.equals("BusinessContract")){
        sTableName = "BUSINESS_CONTRACT";
    }
    if(sResultType.equals("BusinessDueBill")){
        sTableName = "BUSINESS_DUEBILL";
    }
    
    try{
        //�������������,�򲻳�ʼ������
		if(sType.equals("Batch")){
        	//Ŀǰ��������弶��������ֻ��Ԥ����������������ʵ���弶�����������롣
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
                //��CLASSIFY_RECORD����������¼
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
            //��ѯ��ͬ/��ݵ�����ʼ������
            sSql =  " select count(SerialNo) from CLASSIFY_RECORD "+
                    " where ObjectType = '"+sResultType+"' and ObjectNo = '"+sObjectNo+"' and AccountMonth = '"+sAccountMonth+"' ";
            rs = Sqlca.getASResultSet(sSql);
            if (rs.next())
            	iTCount = rs.getInt(1);
            rs.getStatement().close();        
            if(iTCount > 0){
            	out.println("IsExist"); //AJAX����ֵ
            }else{
	            //�����߼����AmarGCI4.0�汾�Ѿ���BUSINESS_DUEBILL���е�CUSTOMERID�ֶθ�ֵ�������BUSINESS_DUEBILL���п���ȡ��CUSTOMERID
	            //������������°汾��AmarGCI��ȡCUSTOMERID�ķ������Լ���� add by cbsu 2009-10-14
	            sSql =  " select Balance,CustomerID from "+sTableName+" where SerialNo = '"+sObjectNo+"' ";                   
	            rs = Sqlca.getASResultSet(sSql);
	            if(rs.next()){
	                dBalance = rs.getDouble("Balance");
	                sCustomerID = rs.getString("CustomerID");
	            }    
	            rs.getStatement().close();
	            //��CLASSIFY_RECORD����������¼
	            sSql = "select SerialNo from classify_record where ObjectType='"+sResultType+"' and ObjectNo='"+sObjectNo+"' and AccountMonth='"+sAccountMonth+"'";
	            sSerialNo = Sqlca.getString(sSql);
	            if(sSerialNo == null || sSerialNo.length() == 0){
	            	sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,StringFunction.getToday(),CurOrg.getOrgID(),CurUser.getUserID(),Sqlca);
	            }else{
	            	//�����ѽ������ݲ��뵽CLASSIFY_RECORD,��˲����ٲ����ˡ�
	            	//����CLASSIFY_DATA���������������ݣ������Ҫ����
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
	            //��ʼ���弶��������
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
		out.println(sSerialNo); //AJAX����ֵ
    }catch(Exception e){
        throw new Exception("������ʧ�ܣ�"+e.getMessage());
    }       
%><%@ include file="/IncludeEndAJAX.jsp"%>