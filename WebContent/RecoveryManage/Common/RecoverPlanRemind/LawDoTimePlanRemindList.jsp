<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("LawDoTimePlanRemindList");
	String sWhereSql = "";
	sWhereSql = " AND LB.BookType =(select  max(LB1.booktype) from jbo.preservation.LAWCASE_BOOK LB1 where LB1.lawcaseserialno=LB.lawcaseserialno and LB1.booktype in('040','050','060') group by LB1.lawcaseserialno ) " +
	           " AND  not exists (select 1 from  jbo.preservation.LAWCASE_BOOK LB2 WHERE O.SERIALNO = LB2.LAWCASESERIALNO AND LB2.BookType = '070') " +
	           " and v.to_char(v.sysdate,'yyyy/mm/dd') between v.to_char(v.add_months(v.to_date(lb.IntoEffectDate, 'yyyy/mm/dd'),23),'yyyy/mm/dd') and v.to_char(v.add_months(v.to_date(lb.IntoEffectDate, 'yyyy/mm/dd'),24),'yyyy/mm/dd') " ; 	           
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql);
	
	String role [] = {"PLBS0052"};
	if(CurUser.hasRole(role)){
		doTemp.appendJboWhere(" and exists (select 1 from jbo.sys.ORG_BELONG OB where OB.orgid='"+CurUser.getOrgID()+"' and OB.BelongOrgID=O.InputOrgID)");
	}else{
		doTemp.appendJboWhere(" and O.InputUserID='"+CurUser.getUserID()+"' ");
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			//{"true","All","Button","����","����","add()","","","","btn_icon_add",""},
			{"true","","Button","��������","��������","viewAndEdit()","","","","btn_icon_detail",""},
			//{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sLawCaseType=getItemValue(0,getRow(),"LawCaseType");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			var sFunctionID="";
			if(sLawCaseType == "01" ){
				sFunctionID = "CaseInfoList1";
			}else{
				sFunctionID = "CaseInfoList2";
			}
			
			AsCredit.openFunction(sFunctionID,"SerialNo="+sObjectNo+"&LawCaseType="+sLawCaseType+"&RightType=ReadOnly");	
			reloadSelf();	
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
