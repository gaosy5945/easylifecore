<%@page import="com.amarsoft.app.oci.bean.Field"%>
<%@page import="com.amarsoft.app.base.util.DateHelper"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.amarsoft.app.oci.bean.OCITransaction"%>
<%@page import="com.amarsoft.app.oci.bean.Message"%>
<%@page import="com.amarsoft.app.oci.instance.CoreInstance"%>
<%@page import="com.amarsoft.app.als.project.QueryMarginBalance"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.jbo.BizObjectManager"%>
<%@page import="com.amarsoft.are.jbo.BizObjectQuery"%>
<%@page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@page import="com.amarsoft.are.jbo.JBOTransaction"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	//���ϸ�ҳ��õ�����Ĳ���
	String SerialNo = CurPage.getParameter("SerialNo");//��ͬ���
	if(SerialNo == null) SerialNo = "";
	String BusinessType = CurPage.getParameter("BusinessType");//������Ʒ
	if(BusinessType == null) BusinessType = "";
	
	String sTempletNo = "CreditCLQuery";//--ģ���--
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	//dwTemp.ReadOnly = "-2";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
		{"false","All","Button","����","���������޸�","as_save(0)","","","",""},
	};
	%>
<%/*~END~*/%>
<title>������/�����׶�Ȳ�ѯ</title>
<%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	StringBuffer sJSScript = new StringBuffer();
	JBOTransaction tx = null;
	try{
		tx = JBOFactory.createJBOTransaction();
		
		String TranTellerNo = "92261005";
		String BranchId = "2261";
		String BussType = "";
		if("666".equals(BusinessType)){
			BussType = "0";   //������
		}else if("500".equals(BusinessType)){
			BussType = "1";   //����������
		}else{
			BussType = "2";   //������ת��
		}

		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
		tx.join(table);
		
		BizObjectQuery q = table.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.app.BUSINESS_CONTRACT' and AccountIndicator = '01'").setParameter("ObjectNo", SerialNo);
		BizObject pr = q.getSingleResult(false);
		String CardNo = "";
		if(pr!=null){
			CardNo = pr.getAttribute("AccountNo1").getString();
		}
		try{
			BizObjectManager bmCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(bmCL);
			OCITransaction oci = CoreInstance.XDYOrRZYLoanLmtQry(TranTellerNo, BranchId, "2", CardNo, "", "", "", "", BussType, "", "", 0, tx.getConnection(bmCL));
	
			//ȡ���ر��ĵ�ReturnCode��ReturnMsg���жϷ��ر����Ƿ���ȷ
			String ReturnCode = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnCode");
			String ReturnMsg = oci.getOMessage("SysBody").getFieldByTag("RspSvcHeader").getObjectMessage().getFieldValue("ReturnMsg");
			if(("000000000000").equals(ReturnCode)){
				Field[] fields = oci.getOMessage("SysBody").getFieldByTag("SvcBody").getObjectMessage().getFields();
				if(fields != null)
				{
					for(int i = 0; i < fields.length ; i ++){
						String value = fields[i].getFieldValue();
						%>
						<script type="text/javascript">
						var TagID = "<%=fields[i].getFieldTag()%>";
						var value = "<%=value%>";
						if(TagID == "LmtStatus"){
							if(value == "0"){ value = "����";	}else if(value == "1"){ value = "��ͣ";}else if(value == "2"){ value = "����";}else{ value = "�ر�";}
						}
						if(TagID == "PcsMode"){
							if(value == "1"){ value = "ȫ��ת��";}else if(value == "2"){ value = "ȫ��۱��ý�,���㻹��ȫ��ת��";}
						}
						if(TagID == "RepayMode"){
							if(value == "1"){ value = "�ȶ�";	}else if(value == "2"){ value = "�ȱ�";}else if(value == "3"){ value = "һ�λ�����Ϣ";}else if(value == "4"){ value = "�ִθ�Ϣһ�λ���";}else if(value == "5"){ value = "����/�ݼ�";}
							else if(value == "6"){ value = "���";}else if(value == "7"){ value = "�����¹�(�ȶ�)";}else{ value = "�����¹�(�ȱ�)";}
						}
						if(TagID == "IntActualPrd"){
							if(value == "0"){ value = "���»���";	}else if(value == "1"){ value = "��������";}else if(value == "2"){ value = "���껹��";}else if(value == "3"){ value = "����ѧ����";}else if(value == "4"){ value = "���껹��";}
							else if(value == "5"){ value = "���̶�����";}else{ value = "���汾��";}
						}
						if(TagID == "RepymtDateMode"){
							if(value == "0"){ value = "�����Ϊ������";}else{ value = "ָ����������";}
						}
						if(TagID == "IntRateAdjType"){
							if(value == "1"){ value = "�̶�����";	}else if(value == "2"){ value = "�������";}else if(value == "3"){ value = "�ض����ڱ䶯";}else if(value == "8"){ value = "����";}else if(value == "9"){ value = "����";}
							else{ value = "�ṹ�Թ̶�����";}
						}
						if(TagID =="PnyIntFlotType"){
							if(value == "0"){ value = "�̶���Ϣ��";}else{ value = "����ͬ���ʸ���";}
						}
						if(TagID == "BussType"){
							if(value == "0"){ value = "������";}else if(value == "1"){ value == "����������";}else{ value == "������ת��";}
						}
						if(TagID == "LmtExpDate" || TagID == "CtrExpDate" || TagID == "ActTranDate"){
							value = value.substring(0, 4)+"/"+value.substring(4, 6)+"/"+value.substring(6, 8);
						}
						if(TagID == "RepayDate"){
							value = "ÿ��"+value+"��";
						}
						if(TagID == "IntRateAdjDate"){
							value = "ÿ��"+value.substring(0, 2)+"��"+value.substring(2,4)+"��";
						}
						if(TagID == "FloatPercent"){
								value = (parseFloat(value))*100;
						}
						setItemValue(0,0,"<%=fields[i].getFieldTag()%>",value);
						</script>
						<%	
					}
				}
			}
		}catch(Exception ex){
			String msg = ex.getMessage();
			%> <script type="text/javascript"> alert("<%=msg%>");  </script><%
		}
		tx.commit();
	}catch(Exception ex){
		tx.rollback();
		throw ex;
	}

%>
<%/*~END~*/%>




<%@ include file="/Frame/resources/include/include_end.jspf"%>
