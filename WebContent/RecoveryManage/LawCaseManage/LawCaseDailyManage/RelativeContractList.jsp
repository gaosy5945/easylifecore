<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zqliu
		Tester:
		Content: ������غ�ͬ�б�
		Input Param:
				SerialNo:�������				  
		Output param:
				
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������غ�ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";	
	
	//������������������ˮ�ţ�		
	String sSerialNo =   CurComp.getParameter("SerialNo");//DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";	
   //��ȡ��ͬ�ս�����
    String sFinishType =CurComp.getParameter("FinishType"); //DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    if(sFinishType == null) sFinishType = "";
    //��ȡ�鵵����
    String sPigeonholeDate =CurComp.getParameter("PigeonholeDate"); //DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PigeonholeDate"));   
    if( sPigeonholeDate == null) sPigeonholeDate = "";
	
%>
<%/*~END~*/%>


<%

	String sTempletNo = "RelativeContractList";//ģ�ͱ��
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sSerialNo);

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
			{"true","All","Button","���������ͬ","���������ͬ��Ϣ","my_relativecontract()","","","",""},
			{"true","","Button","��ͬ����","�鿴��ͬ����","viewAndEdit()","","","",""},
			{"true","All","Button","ȡ��������ͬ","����������ͬ�Ĺ�����ϵ","deleteRecord()","","","",""},
			//{"true","","Button","����ƻ��Ǽ�","����ƻ��Ǽ�","addcrs()","","","",""},
			//{"true","","Button","���յǼ�","���յǼ�","viewAndEdit()","","","",""},
			//{"true","","Button","�ſ��¼��ѯ","�ſ��¼��ѯ","viewAndEdit()","","","",""},
			//{"true","","Button","���䶯��¼��ѯ","���䶯��¼��ѯ","viewAndEdit()","","","",""},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ContractInfo;Describe=�鿴��ͬ����;]~*/%>
	<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
		
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");  
		var sObjectNo = getItemValue(0,getRow(),"OBJECTNO");  
		var sObjectType = getItemValue(0,getRow(),"OBJECTTYPE");  
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			//ɾ����������ѡ��ͬ�Ĺ�����ϵ
			sReturn = RunMethod("BusinessManage","DeleteRelative",sSerialNo+","+sObjectType+","+sObjectNo+",LAWCASE_RELATIVE");
			if(sReturn > -1)
			{
				alert(getBusinessMessage("751"));//�ð����Ĺ�����ͬɾ���ɹ���
				OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
			}else
			{
				alert(getBusinessMessage("752"));//�ð����Ĺ�����ͬɾ��ʧ�ܣ������²�����
				return;
			}			
		}
	}	

	function my_relativecontract()
	{ 
		<%-- var sURL = "/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractChooseList.jsp";
		var sPara = "";
		var sStyle = "";
		var dialogArgs = "";
		AsControl.PopComp(sURL, sPara, sStyle, dialogArgs);
		//��ȡ���������ĺ�ͬ��ˮ��	
		--%>
		var sRelativeContractNo ;	
		var sContractInfo = AsDialog.SelectGridValue('RelativeContractChooseList',"<%=CurUser.getOrgID()%>",'SERIALNO','',"true","",'','1');
		//var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_") 
		{
			sRelativeContractNo = sContractInfo.split('~');
		}
		//���ѡ���˺�ͬ��Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ�İ��������˹�����������������ϵ��
		if(typeof(sRelativeContractNo) != "undefined" && sRelativeContractNo != "") 
		{
			for(var k=0;k<sRelativeContractNo.length;k++){
				sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,LAWCASE_RELATIVE,String@SerialNo@"+"<%=sSerialNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeContractNo[k]);
				if(typeof(sReturn) != "undefined" && sReturn != "") 
				{			
					sReturn = sReturn.split('~');
					var my_array = new Array();
					for(i = 0;i < sReturn.length;i++)
					{
						my_array[i] = sReturn[i];
					}
					
					for(j = 0;j < my_array.length;j++)
					{
						sReturnInfo = my_array[j].split('@');				
						if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
						{						
							if(sReturnInfo[0] == "objectno")
							{
								if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeContractNo[k])
								{
									alert(sRelativeContractNo[k]+getBusinessMessage("753"));//��ѡ��ͬ�ѱ��ð�������,�����ٴ����룡
									return;
								}
							}				
						}
					}			
				}
				//������������ѡ��ͬ�Ĺ�����ϵ
				sReturn = RunMethod("BusinessManage","InsertRelative","<%=sSerialNo%>"+",BusinessContract,"+sRelativeContractNo[k]+",LAWCASE_RELATIVE");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert(sRelativeContractNo[k]+getBusinessMessage("754"));//���������ͬ�ɹ���
					OpenPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/RelativeContractList.jsp","right","");	
				}else {
					alert(sRelativeContractNo[k]+getBusinessMessage("755"));//���������ͬʧ�ܣ������²�����
					return;
				}
			}	
		}
	}

	/*~[Describe=�鿴��ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		/* var sOBJECTNO = getItemValue(0,getRow(0),'OBJECTNO');//��ͬ��ˮ��
		var sCustomerID = getItemValue(0,getRow(0),'CustomerID');
		AsCredit.openFunction("ContractInfo", "ObjectNo="+sOBJECTNO+"&CustomerID="+sCustomerID);
		 */
		var serialNo = getItemValue(0,getRow(0),'OBJECTNO');
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("ContractTab", "SerialNo="+serialNo+"&rightType=ReadOnly");

		reloadSelf();
	}	
	//����ƻ��Ǽ�
	function addcrs(){
		var taskSerialNo = getItemValue(0,getRow(0),'TaskSerialNo');
		var objectNo = getItemValue(0,getRow(0),'SerialNo');
	 	if(typeof(taskSerialNo)=="undefined" || taskSerialNo.length==0 ){
			alert("��������Ϊ�գ�");
			return ;
	 	}
		AsCredit.openFunction("CollRepaymentList","TaskSerialNo="+taskSerialNo+"&ObjectNo="+objectNo);
		reloadSelf();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	
	//init();
	//my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
