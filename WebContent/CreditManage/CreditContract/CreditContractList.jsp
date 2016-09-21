<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	/*
		Author:   qzhang  2004/12/02
		Tester:
		Content: ��ͬ��Ϣ�б�
		Input Param:	 
		Output param:
		History Log: 
	*/

	//��ȡǰ�˴���Ĳ���
    String sTemplateNo = DataConvert.toString(CurPage.getParameter("TemplateNo"));//ģ���
    String sStatus = DataConvert.toString(CurPage.getParameter("Status"));//ģ���
    
	ASObjectModel doTemp = new ASObjectModel(sTemplateNo); 
    
    if(CurUser.hasRole("PLBS0001") || CurUser.hasRole("PLBS0002"))
    {
    	doTemp.appendJboWhere(" and O.OperateUserID=:UserID ");
    }
    
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.setParameter("UserID", CurUser.getUserID());
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow(CurUser.getOrgID()+","+CurUser.getUserID());

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��ͬ����","��ͬ����","create()","","","","",""},
			{"true","","Button","��ͬ����","��ͬ����","edit()","","","","",""},
			{"false","","Button","��ӡ���Ӻ�ͬ","��ӡ���Ӻ�ͬ","print()","","","","",""},
		};
	 if("010".equals(sStatus)){
		sButtons[0][0] = "true";
	}

%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function create(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");		
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("DocContractTab", "SerialNo="+serialNo);
	}
	function edit(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsCredit.openFunction("ContractTab", "SerialNo="+serialNo+"&rightType=ReadOnly");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
