<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��Ŀ������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql="";//--���sql���
	String sProjectType="";//--��Ŀ����
	ASResultSet rs=null;
	//��������������Ŀ���
	String sProjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//���ҳ�����	

	//�����Ŀ����
	sSql = "select ProjectType  from PROJECT_INFO where ProjectNo=:ProjectNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ProjectNo",sProjectNo));
	if(rs.next())
	   sProjectType =DataConvert.toString(rs.getString("ProjectType"));//--��Ŀ����
	rs.getStatement().close(); 
	if(sProjectType == null ) sProjectType = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ProjectInfo";//--ģ������
	String sTempletFilter="  ColAttribute like '%"+sProjectType+"%'";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//�Զ�������Ŀ�ʱ������(%)
	doTemp.setHTMLStyle("PlanTotalCast,ProjectCapital"," onchange=parent.getCapitalScale() ");
				
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����setEvent
	//���ò���͸����¼�
    dwTemp.setEvent("AfterUpdate","!ProjectManage.AddProjectRelative(#ProjectNo,"+sObjectType+",#ObjectNo)");
   
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","All","Button","����","���������޸�","saveRecord()","","","",""}		
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
	    var	sCapitalScale = getItemValue(0,getRow(),"CapitalScale");
        if(sCapitalScale<0||sCapitalScale>100){
        	alert("��Ŀ�ʽ����Ӧ����[0,100]");
        	return;
        }
		as_save("myiframe0",sPostEvents);	
	}
		
	/*~[Describe=������Ŀ�ʱ������;InputParam=��;OutPutParam=��;]~*/
	function getCapitalScale(){
		//�ƻ���Ͷ��(Ԫ)
		sPlanTotalCast = getItemValue(0,getRow(),"PlanTotalCast");//--�ƻ���Ͷ��
		if(typeof(sPlanTotalCast) == "undefined" || sPlanTotalCast.length == 0){
			sPlanTotalCast=1;
		    setItemValue(0,getRow(),"CapitalScale","");
		     return;
		}
		//��Ŀ�ʱ���(Ԫ)
		sProjectCapital = getItemValue(0,getRow(),"ProjectCapital");//--��Ŀ�ʱ���
		if(typeof(sProjectCapital) == "undefined" || sProjectCapital.length == 0)
			sProjectCapital=0;
		
		//��Ŀ�ʱ������������
		sProjectCapitalScale = roundOff(sProjectCapital/sPlanTotalCast*100,2);//--��Ŀ�ʽ����
		if(sProjectCapitalScale >= 0){
		   setItemValue(0,getRow(),"CapitalScale",sProjectCapitalScale);
		 }
		 else{//������Ϊ0
		   setItemValue(0,getRow(),"CapitalScale",0);
		 }
	}
	
	/*~[Describe=ѡ�������ҵ����;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType(){
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//������ҵ��������м������������ʾ��ҵ����
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != ""){
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
			sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ProjectNo","<%=sProjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		
			bIsInsert = true;
		}
    }
    
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>