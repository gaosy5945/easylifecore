<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ����������������еǼ�;
		Input Param:
					DealType��
						01����ǩ���ͬ��֪ͨ�飨һ������ҵ��
						02����ɲ�����֪ͨ�飨һ������ҵ��
		Output Param:
			
		HistoryLog: zywei 2005/08/13 �ؼ�ҳ��
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sCondition="";	
    String sWhereCond = "";
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//where���ͳһ�޸Ĵ����漰ҵ������ģ����				
	sWhereCond	= " and OperateUserID ='"+CurUser.getUserID()+"' and ApproveType = '01' "
							  +" and (RelativeSerialNo in (select ObjectNo from FLOW_OBJECT where ObjectType='CreditApply' "+
			                   " and PhaseNo='1000') or "+
			                   " RelativeSerialNo in (select AR.SerialNo from APPLY_RELATIVE AR where AR.ObjectNo=RelativeSerialNo and AR.ObjectType='CreditApply' and AR.SerialNo in (select FO.ObjectNo from FLOW_OBJECT FO where FO.ObjectType='CreditApply' "+
			                   " and PhaseNo='1000'))) ";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DealApproveList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sDealType.equals("01")){
		sCondition = " and Flag5 = '010' ";
	}
	else if(sDealType.equals("02")){
		sCondition = " and Flag5 = '020' ";
	}
	doTemp.WhereClause = doTemp.WhereClause + sWhereCond + sCondition;

	doTemp.setKeyFilter("SerialNo");
	doTemp.setHTMLStyle("","ondblclick=\"javascript:parent.viewTab()\" ");//���˫���鿴���鹦��
	//���ӹ����� 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","���������������","���������������","viewTab()","","","",""},
		{"true","","Button","�ǼǺ�ͬ","�ǼǺ�ͬ","BookInContract()","","","",""}
		}; 
	if(sDealType.equals("02"))
		sButtons[1][0]="false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�ǼǺ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function BookInContract(){
		//������������,��������������,���ڶ����Ч�Լ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sApplyType = getItemValue(0,getRow(),"ApplyType");//��������
		var sObjectType = "ApproveApply";//��������
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			/********************add by hwang 20090630,���ڶ������ҵ�����Ӷ����Ч�Լ��*******************************/
			sReturn = autoRiskScan("010","OccurType="+sOccurType+"&ApplyType="+sApplyType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo);
			if(sReturn != true){
				return;
			}
			
			if(!confirm("��ȷ��Ҫ����ѡ�еĵ���������������ǼǺ�ͬ�� \n\rȷ���󽫸�����������������ɺ�ͬ��")){
				return;
			}

		    sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.InitializeContract","initialize","ApproveSerialNo="+sSerialNo+",UserID=<%=CurUser.getUserID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		    var sContractNo = sReturn;
		    if(sReturn.indexOf("@")>-1){
		    	sContractNo = sReturn.split("@")[0];
		    	sReturn = sReturn.replace(/@/g,",");
		    }
		    if(sApplyType=="CreditLineApply"||sApplyType=="DependentApply"){
				 alert("������������������ɺ�ͬ�ɹ�����ͬ��ˮ��["+sReturn+"]��\n\r�������д��ͬҪ�ز������桱���Ժ��ڡ����Ǽ���ɵ����Ŷ�ȡ��б���ѡ��ú�ͬ����д��ͬҪ�أ�");
            }else{
            	 alert("������������������ɺ�ͬ�ɹ�����ͬ��ˮ��["+sReturn+"]��\n\r�������д��ͬҪ�ز������桱���Ժ��ڡ�����ɷŴ��ĺ�ͬ���б���ѡ��ú�ͬ����д��ͬҪ�أ�");
            }
		    
			sObjectType = "BusinessContract";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sContractNo+"&ViewID=001";
			AsCredit.openImageTab(sParamString);
			reloadSelf();
		}
	}
    
	/*~[Describe=�鿴���������������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "ApproveApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	 	sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		AsCredit.openImageTab(sParamString); 
		
		
 	//	var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&CustomerID=" + sCustomerID;
	//	AsCredit.openFunction("ApproveDetail",sParamString,"");  
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>