<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%><%@ 	
 page import="com.amarsoft.are.jbo.*,com.amarsoft.biz.formatdoc.model.*" %><%
	//������ʵ�ֻ�ȡ��ʽ�������ض�ҳ������ݶ����ֵ
	
	String sDocID    = "D001";    		//���鱨���ĵ����-awe_erpt_record.docid(ȡֵ����awe_erpt_catalog.docid)
	String sObjectNo = "2011062400000017"; 		//ҵ����ˮ��-awe_erpt_record.objectno
	String sObjectType = "CreditApply"; 	//��������-awe_erpt_record.objecttype
	String sDirID = "00";//����ҳ���� awe_erpt_data.dirid(ȡֵ����awe_erpt_def.dirid)
	//����sDocID��sObjectNo��sObjectType��sDirID��ȡawe_erpt_data.serialno
	String sSerialNo = "";
	BizObjectManager manager = JBOFactory.getBizObjectManager("jbo.app.FORMATDOC_DATA");
	String sql = "select o.serialno from o,jbo.app.FORMATDOC_RECORD fr where o.relativeserialno=fr.serialno"
			+ " and o.dirid=:dirid and fr.objectno=:objectno and fr.objecttype=:objecttype and fr.docid=:docid";
	BizObjectQuery query = manager.createQuery(sql);
	query.setParameter("docid", sDocID);
	query.setParameter("objectno", sObjectNo);
	query.setParameter("objecttype", sObjectType);
	query.setParameter("dirid", sDirID);
	BizObject obj = query.getSingleResult(false);
	if(obj==null)
		throw new Exception("��Ч�Ĳ���");//��ѯ����awe_erpt_data.serialno
	else{
		//�����ˮ��
		sSerialNo = obj.getAttribute("serialno").getString();
		//��ԭ����,����1��awe_erpt_data.serialno,����2:�̶�Ϊcom.amarsoft,����3:��ҪΪ��ȡͼƬ����Դ
		//����awe_erpt_catalog��awe_erpt_def���ÿ�֪����ԭ��������Ϊcom.amarsoft.app.awe.framecase.formatdoc.template01.D001_00.java
		com.amarsoft.app.awe.framecase.formatdoc.template01.D001_00 fd = (com.amarsoft.app.awe.framecase.formatdoc.template01.D001_00)FormatDocHelp.getFDDataObject(sSerialNo, "com.amarsoft", new FormatDocConfig(request));
		//��ӡ����
		%>
		operateOrgName = <%=fd.getOperateOrgName()%><br>
		customerName = <%=fd.getCustomerName()%><br>
		...<br>
		<%
	}
	String sButtons[][] = {
		{"true","","Button","ˢ��","ˢ��","reloadSelf()","","","",""},//btn_icon_add
	};
%>
<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
<%@ include file="/IncludeEnd.jsp"%>