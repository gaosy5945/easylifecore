package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;

public class CR_081_07 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	private DocExtClass extobjc0;
	private DocExtClass extobjc1;
	private DocExtClass extobjc2;
//	private DocExtClass extobjc3;
	private DocExtClass extobjc4;
//	private DocExtClass extobjc5;
	private DocExtClass extobjc6;
	private DocExtClass extobjc7;
	private DocExtClass extobjc8;
	private DocExtClass extobjc9;
	private DocExtClass extobjc10;
	private DocExtClass extobjc11;
	private DocExtClass extobjc12;
	private DocExtClass extobjc13;
	private DocExtClass extobjc14;
	private DocExtClass extobjc15;
	private DocExtClass extobjc16;
	private DocExtClass extobjc17;
	private DocExtClass extobjc18;
	private DocExtClass extobjc19;
	private DocExtClass extobjc20;
	private DocExtClass extobjc21;
	private DocExtClass extobjc22;
	private DocExtClass extobjc23;
	private DocExtClass extobjc24;
	private DocExtClass extobjc25;
	private DocExtClass[] extobjc26;
	private DocExtClass[] extobjp;
	private String totals = "";
	private String opinion1 = "";
	private String opinion2 = "";
	private String opinion3 = "";
	private String opinion4 = "";
	private String opinion5 = "";
	private String opinion6 = "";
	private String opinion7 = "";
	private String opinion8 = "";
	//������ҵ��λ����
	private DocExtClass extobj0;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private DocExtClass extobj3;
    private DocExtClass extobj4;
    private DocExtClass extobj5;
    private DocExtClass extobj6;
    // ҽ���౨��
   
    private DocExtClass extobj7;
    private DocExtClass extobj8;
    private DocExtClass extobj9;
    private DocExtClass extobj10;
    private DocExtClass extobj11;
    private DocExtClass extobj12;
    private DocExtClass extobj13;
    private DocExtClass extobj14;
	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	String customerID = "";
	String sFinancelType = "";
	
	BizObjectManager m1 = null;
	BizObjectQuery q1 = null;
	BizObject bo1 = null;
	
	public CR_081_07() {
	}
	
//	//ȡ�ͻ�������Ϣ
//	public void getCustomer(String customerID){
//		String sObjectNo=this.getRecordObjectNo();
//		if(sObjectNo==null)sObjectNo="";
//		String guarantyNo = this.getGuarantyNo();	
//		if(guarantyNo==null)guarantyNo="";
//		try {
//			if(guarantyNo!=null&& !"".equals(guarantyNo)){
//				m = JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO");
//				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
//				bo = q.getSingleResult();
//				if(bo != null){
//					customerID = bo.getAttribute("COLASSETOWNER").getString();
//				}
//			}
//			if(!StringX.isSpace(customerID)){
//				sFinancelType = getReportType(customerID);
//					m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
//					q = m.createQuery("customerno = :CustomerID").setParameter("CustomerID",customerID);
//					List<BizObject> guarantys = q.getResultList();
//					extobjp = new DocExtClass[guarantys.size()];
//					if(guarantys.size() >0){
//						for(int i=0;i<guarantys.size();i++){
//							BizObject guaranty = guarantys.get(i);
//							extobjp[i] = new DocExtClass();
//							extobjp[i].setAttr1(guaranty.getAttribute("RatingPerion").getString());
//							extobjp[i].setAttr2(guaranty.getAttribute("ModeGrade01").getString());
//							extobjp[i].setAttr3(guaranty.getAttribute("RatingGrade99").getString());
//							String effState = guaranty.getAttribute("EffState").getString();
//							String finishDate = guaranty.getAttribute("FinishDate").getString();
//							if(effState.equals("1")&& StringX.isSpace(finishDate)){
//								extobjp[i].setAttr4("��");
//							}else{
//								extobjp[i].setAttr4("��");
//							}
//						}
//					}
//			}
//		}catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
		
	public boolean initObjectForRead() {
//		extobjc0 = new DocExtClass();
//		extobjc1 = new DocExtClass();
//		extobjc2 = new DocExtClass();
////		extobjc3 = new DocExtClass();
//		extobjc4 = new DocExtClass();
////		extobjc5 = new DocExtClass();
//		extobjc6 = new DocExtClass();
//		extobjc7 = new DocExtClass();
//		extobjc8 = new DocExtClass();
//		extobjc9 = new DocExtClass();
//		extobjc10 = new DocExtClass();
//		extobjc11 = new DocExtClass();
//		extobjc12 = new DocExtClass();
//		extobjc13 = new DocExtClass();
//		extobjc14 = new DocExtClass();
//		extobjc15 = new DocExtClass();
//		extobjc16 = new DocExtClass();
//		extobjc17 = new DocExtClass();
//		extobjc18 = new DocExtClass();
//		extobjc19 = new DocExtClass();
//		extobjc20 = new DocExtClass();
//		extobjc21 = new DocExtClass();
//		extobjc22 = new DocExtClass();
//		extobjc23 = new DocExtClass();
//		extobjc24 = new DocExtClass();
//		extobjc25 = new DocExtClass();
//		//������ҵ��λ
//		extobj0 = new DocExtClass();
//		extobj1 = new DocExtClass();
//		extobj2 = new DocExtClass();
//		extobj3 = new DocExtClass();
//		extobj4 = new DocExtClass();
//		extobj5 = new DocExtClass();
//		extobj6 = new DocExtClass();
//		
//		//ҽ����
//		extobj7 = new DocExtClass();
//		extobj8 = new DocExtClass();
//		extobj9 = new DocExtClass();
//		extobj10 = new DocExtClass();
//		extobj11 = new DocExtClass();
//		extobj12 = new DocExtClass();
//		extobj13 = new DocExtClass();
//		extobj14 = new DocExtClass();
//		
//		String sObjectNo=this.getRecordObjectNo();
//		if(sObjectNo==null)sObjectNo="";
//		String guarantyNo = this.getGuarantyNo();	
//		if(guarantyNo==null)guarantyNo="";
//		try {
//			if(guarantyNo!=null&& !"".equals(guarantyNo)){
//				m = JBOFactory.getFactory().getManager("jbo.app.GUARANTY_INFO");
//				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
//				bo = q.getSingleResult();
//				if(bo != null){
//					customerID = bo.getAttribute("COLASSETOWNER").getString();
//				}
//			}
//			if(!StringX.isSpace(customerID)){
//				sFinancelType = getReportType(customerID);
//				if(sFinancelType.equals("010")||sFinancelType.equals("020")){
//					m = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
//					q = m.createQuery("customerno = :CustomerID").setParameter("CustomerID",customerID);
//					List<BizObject> guarantys = q.getResultList();
//					extobjp = new DocExtClass[guarantys.size()];
//					if(guarantys.size() >0){
//						for(int i=0;i<guarantys.size();i++){
//							BizObject guaranty = guarantys.get(i);
//							extobjp[i] = new DocExtClass();
//							extobjp[i].setAttr1(guaranty.getAttribute("RatingPerion").getString());
//							extobjp[i].setAttr2(guaranty.getAttribute("ModeGrade01").getString());
//							extobjp[i].setAttr3(guaranty.getAttribute("RatingGrade99").getString());
//							String effState = guaranty.getAttribute("EffState").getString();
//							String finishDate = guaranty.getAttribute("FinishDate").getString();
//							if(effState.equals("1")&& StringX.isSpace(finishDate)){
//								extobjp[i].setAttr4("��");
//							}else{
//								extobjp[i].setAttr4("��");
//							}
//						}
//					}
//					
//					FinanceDataManager fdm=new FinanceDataManager();
//					CustomerFSRecord cfs=fdm.getNewestReport(customerID);
//					CustomerFSRecord yearReport = fdm.getNewYearReport(customerID);
//					ReportSubject rs = null;
//					if(cfs != null){
//						if(!StringX.isSpace(cfs.getReportDate()))extobjc0.setAttr1("("+cfs.getReportDate()+")");
//						Map reportMap = fdm.getGuideMap(cfs);
//						if(reportMap.size()>0){
//							rs = (ReportSubject) reportMap.get("��������(��)");
//							extobjc1.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("�ٶ�����(��)");
//							extobjc2.setAttr1(rs.getCol2ValueString());
////					rs = (ReportSubject) reportMap.get("�����ٶ�����(��)");
////					extobjc3.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("�ֽ����(��)");
//							extobjc4.setAttr1(rs.getCol2ValueString());
////					rs = (ReportSubject) reportMap.get("Ӫ���ʱ�");
////					extobjc5.setAgetCol2IntString()String());
//							rs = (ReportSubject) reportMap.get("�ʲ���ծ��(%)");
//							extobjc6.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("��������ʲ���ծ��(%)");
//							extobjc7.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("���ֱ���(���Ը�ծ����)(%)");
//							extobjc8.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("��Ȩ����(%)");
//							extobjc9.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("���ξ�ֵծ����(%)");
//							extobjc10.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("��Ϣ���ϱ���(��)");
//							extobjc11.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("����ë����(%)");
//							extobjc12.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("Ӫҵ������(%)");
//							extobjc13.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("˰ǰ������(%)");
//							extobjc14.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("���۾�����(%)");
//							extobjc15.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("�ɱ�����������(%)");
//							extobjc16.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//							extobjc17.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//							extobjc18.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//							extobjc19.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("�����ת��(��)");
//							extobjc20.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//							extobjc21.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("��Ӫҵ����(��)");
//							extobjc22.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("�����ʲ���ת��(��)");
//							extobjc23.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("�̶��ʲ���ת��(��)");
//							extobjc24.setAttr1(rs.getCol2ValueString());
//							rs = (ReportSubject) reportMap.get("���ʲ���ת��(��)");
//							extobjc25.setAttr1(rs.getCol2ValueString());
//						}
//						
//						CustomerFSRecord cfs1 = fdm.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
//						if(cfs1 != null){
//							if(!StringX.isSpace(cfs1.getReportDate()))extobjc0.setAttr2("("+cfs1.getReportDate()+")");
//							reportMap = fdm.getGuideMap(cfs1);
//							if(reportMap.size()>0){
//								rs = (ReportSubject) reportMap.get("��������(��)");
//								extobjc1.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ٶ�����(��)");
//								extobjc2.setAttr2(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("�����ٶ�����(��)");
////						extobjc3.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ֽ����(��)");
//								extobjc4.setAttr2(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("Ӫ���ʱ�");
////						extobjc5.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ʲ���ծ��(%)");
//								extobjc6.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��������ʲ���ծ��(%)");
//								extobjc7.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ֱ���(���Ը�ծ����)(%)");
//								extobjc8.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ȩ����(%)");
//								extobjc9.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ξ�ֵծ����(%)");
//								extobjc10.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ϣ���ϱ���(��)");
//								extobjc11.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("����ë����(%)");
//								extobjc12.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӫҵ������(%)");
//								extobjc13.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("˰ǰ������(%)");
//								extobjc14.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���۾�����(%)");
//								extobjc15.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ɱ�����������(%)");
//								extobjc16.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc17.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc18.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc19.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ת��(��)");
//								extobjc20.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc21.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ӫҵ����(��)");
//								extobjc22.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ʲ���ת��(��)");
//								extobjc23.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�̶��ʲ���ת��(��)");
//								extobjc24.setAttr2(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ���ת��(��)");
//								extobjc25.setAttr2(rs.getCol2ValueString());
//							}
//						}
//						
//						CustomerFSRecord cfs2 = fdm.getRelativeYearReport(cfs, -1);//���ȥ����ĩ
//						if(cfs2 != null){
//							if(!StringX.isSpace(cfs2.getReportDate()))extobjc0.setAttr3("("+cfs2.getReportDate()+")");
//							reportMap = fdm.getGuideMap(cfs2);
//							if(reportMap.size()>0){
//								rs = (ReportSubject) reportMap.get("��������(��)");
//								extobjc1.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ٶ�����(��)");
//								extobjc2.setAttr3(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("�����ٶ�����(��)");
////						extobjc3.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ֽ����(��)");
//								extobjc4.setAttr3(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("Ӫ���ʱ�");
////						extobjc5.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ʲ���ծ��(%)");
//								extobjc6.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��������ʲ���ծ��(%)");
//								extobjc7.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ֱ���(���Ը�ծ����)(%)");
//								extobjc8.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ȩ����(%)");
//								extobjc9.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ξ�ֵծ����(%)");
//								extobjc10.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ϣ���ϱ���(��)");
//								extobjc11.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("����ë����(%)");
//								extobjc12.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӫҵ������(%)");
//								extobjc13.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("˰ǰ������(%)");
//								extobjc14.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���۾�����(%)");
//								extobjc15.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ɱ�����������(%)");
//								extobjc16.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc17.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc18.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc19.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ת��(��)");
//								extobjc20.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc21.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ӫҵ����(��)");
//								extobjc22.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ʲ���ת��(��)");
//								extobjc23.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�̶��ʲ���ת��(��)");
//								extobjc24.setAttr3(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ���ת��(��)");
//								extobjc25.setAttr3(rs.getCol2ValueString());
//							}
//						}
//						
//						CustomerFSRecord cfs3 = fdm.getRelativeYearReport(cfs, -2);//���������ĩ
//						if(cfs3 != null){
//							if(!StringX.isSpace(cfs3.getReportDate()))extobjc0.setAttr4("("+cfs3.getReportDate()+")");
//							reportMap = fdm.getGuideMap(cfs3);
//							if(reportMap.size()>0){
//								rs = (ReportSubject) reportMap.get("��������(��)");
//								extobjc1.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ٶ�����(��)");
//								extobjc2.setAttr4(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("�����ٶ�����(��)");
////						extobjc3.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ֽ����(��)");
//								extobjc4.setAttr4(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("Ӫ���ʱ�");
////						extobjc5.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ʲ���ծ��(%)");
//								extobjc6.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��������ʲ���ծ��(%)");
//								extobjc7.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ֱ���(���Ը�ծ����)(%)");
//								extobjc8.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ȩ����(%)");
//								extobjc9.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ξ�ֵծ����(%)");
//								extobjc10.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ϣ���ϱ���(��)");
//								extobjc11.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("����ë����(%)");
//								extobjc12.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӫҵ������(%)");
//								extobjc13.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("˰ǰ������(%)");
//								extobjc14.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���۾�����(%)");
//								extobjc15.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ɱ�����������(%)");
//								extobjc16.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc17.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc18.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc19.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ת��(��)");
//								extobjc20.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc21.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ӫҵ����(��)");
//								extobjc22.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ʲ���ת��(��)");
//								extobjc23.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�̶��ʲ���ת��(��)");
//								extobjc24.setAttr4(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ���ת��(��)");
//								extobjc25.setAttr4(rs.getCol2ValueString());
//							}
//						}
//						
//						CustomerFSRecord cfs4 = fdm.getRelativeYearReport(cfs, -3);//���������ĩ
//						if(cfs4 != null){
//							if(!StringX.isSpace(cfs4.getReportDate()))extobjc0.setAttr5("("+cfs4.getReportDate()+")");
//							reportMap = fdm.getGuideMap(cfs4);
//							if(reportMap.size()>0){
//								rs = (ReportSubject) reportMap.get("��������(��)");
//								extobjc1.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ٶ�����(��)");
//								extobjc2.setAttr5(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("�����ٶ�����(��)");
////						extobjc3.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ֽ����(��)");
//								extobjc4.setAttr5(rs.getCol2ValueString());
////						rs = (ReportSubject) reportMap.get("Ӫ���ʱ�");
////						extobjc5.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ʲ���ծ��(%)");
//								extobjc6.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��������ʲ���ծ��(%)");
//								extobjc7.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ֱ���(���Ը�ծ����)(%)");
//								extobjc8.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ȩ����(%)");
//								extobjc9.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ξ�ֵծ����(%)");
//								extobjc10.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ϣ���ϱ���(��)");
//								extobjc11.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("����ë����(%)");
//								extobjc12.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӫҵ������(%)");
//								extobjc13.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("˰ǰ������(%)");
//								extobjc14.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���۾�����(%)");
//								extobjc15.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�ɱ�����������(%)");
//								extobjc16.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc17.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ�������(%)");
//								extobjc18.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc19.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ת��(��)");
//								extobjc20.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("Ӧ���˿���ת��(��)");
//								extobjc21.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("��Ӫҵ����(��)");
//								extobjc22.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�����ʲ���ת��(��)");
//								extobjc23.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("�̶��ʲ���ת��(��)");
//								extobjc24.setAttr5(rs.getCol2ValueString());
//								rs = (ReportSubject) reportMap.get("���ʲ���ת��(��)");
//								extobjc25.setAttr5(rs.getCol2ValueString());
//							}
//						}
//					}
//					//��˰��Ϣ
//					m = JBOFactory.getFactory().getManager("jbo.finasys.TAX_PAY");
//					String reportNo = fdm.getDetailNo(cfs);//���ڱ�����
//					q = m.createQuery("ReportNo = :reportNo ").setParameter("reportNo", reportNo);
//					List<BizObject> taxPays = q.getResultList();
//					extobjc26 = new DocExtClass[taxPays.size()];
//					if(taxPays.size()>0){
//						for(int i=0;i<taxPays.size();i++){
//							BizObject taxPay = taxPays.get(i);
//							extobjc26[i] = new DocExtClass();
//							String taxType = taxPay.getAttribute("TAXTYPE").getString();
//							extobjc26[i].setAttr0(CodeManager.getItemName("TaxType", taxType));
//							String taxBased = taxPay.getAttribute("TAXBASED").getString();
//							extobjc26[i].setAttr1(CodeManager.getItemName("RateElements", taxBased));
//							extobjc26[i].setAttr2(taxPay.getAttribute("TAXPAYDATE").getString());
//							extobjc26[i].setAttr3(taxPay.getAttribute("BAILRATE").getString());
//							extobjc26[i].setAttr4(DataConvert.toMoney(taxPay.getAttribute("BALANCE").getDouble()));
//						}
//					}
//					//��ѯ�ϼƽ��
//					q = m.createQuery("select sum(BALANCE) as v.sumBal from o where ReportNo = :reportNo ").setParameter("reportNo", reportNo);
//					bo = q.getSingleResult();
//					if(bo != null){
//						totals = DataConvert.toMoney(bo.getAttribute("sumBal").getDouble());
//					}
//				}else if(sFinancelType.equals("030")){
//					getOE();
//				}else if(sFinancelType.equals("050")){
//					getMED();
//				}else if(sFinancelType.equals("040")){
//					getED();
//				}
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			return false;
//		}
		return true;
	}
	
	//������
//	public void getED(){
//		//ȡ�ͻ�������Ϣ
//		getCustomer(customerID);
//		
//		ReportSubject rs = null;
//		FinanceDataManager financedata = new FinanceDataManager();
//		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
//		String reportType = cfs.getFinanceBelong();
//		if(cfs != null){
//			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
//			Map reportMap = financedata.getGuideMap(cfs);
//			rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//			extobj1.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//			extobj2.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��ҵ��һ�ξ�ҵ/��ѧ��(%)");
//			extobj3.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��������������(%)");
//			extobj4.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("�����ƻ������(%)");
//			extobj5.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ʦ�ʱ���(%)");
//			extobj6.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("����������������(%)");
//			extobj7.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("֧��Ԥ�������(%)");
//			extobj8.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//			extobj9.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//			extobj10.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//			extobj11.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//			extobj12.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��������");
//			extobj13.setAttr1(rs.getCol2ValueString());
//			
//			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
//			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs1);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ҵ��һ�ξ�ҵ/��ѧ��(%)");
//				extobj3.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������������(%)");
//				extobj4.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("�����ƻ������(%)");
//				extobj5.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ʦ�ʱ���(%)");
//				extobj6.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����������������(%)");
//				extobj7.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("֧��Ԥ�������(%)");
//				extobj8.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj9.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj10.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj11.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj12.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������");
//				extobj13.setAttr2(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//���ȥ����ĩ
//			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs2);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ҵ��һ�ξ�ҵ/��ѧ��(%)");
//				extobj3.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������������(%)");
//				extobj4.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("�����ƻ������(%)");
//				extobj5.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ʦ�ʱ���(%)");
//				extobj6.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����������������(%)");
//				extobj7.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("֧��Ԥ�������(%)");
//				extobj8.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj9.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj10.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj11.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj12.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������");
//				extobj13.setAttr3(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//���������ĩ
//			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs3);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ҵ��һ�ξ�ҵ/��ѧ��(%)");
//				extobj3.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������������(%)");
//				extobj4.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("�����ƻ������(%)");
//				extobj5.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ʦ�ʱ���(%)");
//				extobj6.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����������������(%)");
//				extobj7.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("֧��Ԥ�������(%)");
//				extobj8.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj9.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj10.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj11.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj12.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������");
//				extobj13.setAttr4(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//���������ĩ
//			if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs4);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ҵ��һ�ξ�ҵ/��ѧ��(%)");
//				extobj3.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������������(%)");
//				extobj4.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("�����ƻ������(%)");
//				extobj5.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ʦ�ʱ���(%)");
//				extobj6.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����������������(%)");
//				extobj7.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("֧��Ԥ�������(%)");
//				extobj8.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj9.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj10.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj11.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj12.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��������");
//				extobj13.setAttr5(rs.getCol2ValueString());
//			}
//		}
//	}
//	
//	//ҽ����
//	public void getMED(){
//		//ȡ�ͻ�������Ϣ
//		getCustomer(customerID);
//		
//		ReportSubject rs = null;
//		FinanceDataManager financedata = new FinanceDataManager();
//		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
//		String reportType = cfs.getFinanceBelong();
//		if(cfs != null){
//			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
//			Map reportMap = financedata.getGuideMap(cfs);
//			rs = (ReportSubject) reportMap.get("�˾�ҵ������");
//			extobj1.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ҩƷ����ռҵ������ı���(%)");
//			extobj2.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ƽ�������˴η���");
//			extobj3.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ƽ��סԺ���շ���");
//			extobj4.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ƽ����������");
//			extobj5.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("����ʹ����(%)");
//			extobj6.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ƽ��ҩƷ��֧������(%)");
//			extobj7.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ƽ��ҽ����֧������(%)");
//			extobj8.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("ҽ����Աˮƽ(%)");
//			extobj9.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//			extobj10.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//			extobj11.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//			extobj12.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//			extobj13.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��֧��");
//			extobj14.setAttr1(rs.getCol2ValueString());
//			
//			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
//			if(cfs1 != null&& cfs1.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs1);
//				rs = (ReportSubject) reportMap.get("�˾�ҵ������");
//				extobj1.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҩƷ����ռҵ������ı���(%)");
//				extobj2.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ�������˴η���");
//				extobj3.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��סԺ���շ���");
//				extobj4.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ����������");
//				extobj5.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����ʹ����(%)");
//				extobj6.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҩƷ��֧������(%)");
//				extobj7.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҽ����֧������(%)");
//				extobj8.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҽ����Աˮƽ(%)");
//				extobj9.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj10.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj11.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj12.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj13.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��֧��");
//				extobj14.setAttr2(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//���ȥ����ĩ
//			if(cfs2 != null&& cfs2.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs2);
//				rs = (ReportSubject) reportMap.get("�˾�ҵ������");
//				extobj1.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҩƷ����ռҵ������ı���(%)");
//				extobj2.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ�������˴η���");
//				extobj3.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��סԺ���շ���");
//				extobj4.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ����������");
//				extobj5.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����ʹ����(%)");
//				extobj6.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҩƷ��֧������(%)");
//				extobj7.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҽ����֧������(%)");
//				extobj8.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҽ����Աˮƽ(%)");
//				extobj9.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj10.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj11.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj12.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj13.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��֧��");
//				extobj14.setAttr3(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//���������ĩ
//			if(cfs3 != null&& cfs3.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs3);
//				rs = (ReportSubject) reportMap.get("�˾�ҵ������");
//				extobj1.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҩƷ����ռҵ������ı���(%)");
//				extobj2.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ�������˴η���");
//				extobj3.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��סԺ���շ���");
//				extobj4.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ����������");
//				extobj5.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����ʹ����(%)");
//				extobj6.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҩƷ��֧������(%)");
//				extobj7.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҽ����֧������(%)");
//				extobj8.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҽ����Աˮƽ(%)");
//				extobj9.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj10.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj11.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj12.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj13.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��֧��");
//				extobj14.setAttr4(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//���������ĩ
//			if(cfs4 != null&& cfs4.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs4);
//				rs = (ReportSubject) reportMap.get("�˾�ҵ������");
//				extobj1.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҩƷ����ռҵ������ı���(%)");
//				extobj2.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ�������˴η���");
//				extobj3.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��סԺ���շ���");
//				extobj4.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ����������");
//				extobj5.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("����ʹ����(%)");
//				extobj6.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҩƷ��֧������(%)");
//				extobj7.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ƽ��ҽ����֧������(%)");
//				extobj8.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("ҽ����Աˮƽ(%)");
//				extobj9.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj10.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj11.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj12.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj13.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��֧��");
//				extobj14.setAttr5(rs.getCol2ValueString());
//			}
//		}
//	}
//	
//	//������ҵ��λ
//	public void getOE(){
//		//ȡ�ͻ�������Ϣ
//		getCustomer(customerID);
//		
//		ReportSubject rs = null;
//		FinanceDataManager financedata = new FinanceDataManager();
//		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
//		String reportType = cfs.getFinanceBelong();
//		if(cfs != null){
//			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
//			Map reportMap = financedata.getGuideMap(cfs);
//			rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//			extobj1.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//			extobj2.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//			extobj3.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//			extobj4.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//			extobj5.setAttr1(rs.getCol2ValueString());
//			rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//			extobj6.setAttr1(rs.getCol2ValueString());
//			
//			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
//			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs1);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj3.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj4.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj5.setAttr2(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj6.setAttr2(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//���ȥ����ĩ
//			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs2);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj3.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj4.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj5.setAttr3(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj6.setAttr3(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//���������ĩ
//			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs3);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj3.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj4.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj5.setAttr4(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj6.setAttr4(rs.getCol2ValueString());
//			}
//			
//			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//���������ĩ
//			if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
//				if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
//				reportMap = financedata.getGuideMap(cfs4);
//				rs = (ReportSubject) reportMap.get("�����Ը���(%)");
//				extobj1.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ӫ������(%)");
//				extobj2.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��ծ�ϼ�/����ϼ�");
//				extobj3.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��֧����");
//				extobj4.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("��Ϣծ��/��ҵ����");
//				extobj5.setAttr5(rs.getCol2ValueString());
//				rs = (ReportSubject) reportMap.get("���ڳ�ծ����");
//				extobj6.setAttr5(rs.getCol2ValueString());
//			}
//		}
//	}
//	
//	public void setModelInputStream()throws Exception{
//		//String sFinancelType = "010";//���»��׼��Ϊ��
//		try{
//			if(sFinancelType.equals("010")||sFinancelType.equals("020")){
//				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_07.html");
//				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_07.html");//templateFileName+"_new.html"�ļ�Ҫ����
//			}else if(sFinancelType.equals("160")){
//				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_assure_07.html");
//				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_assure_07.html");
//			}else if(sFinancelType.equals("030")){
//				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_OE_07.html");
//				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_OE_07.html");
//			}else if(sFinancelType.equals("050")){
//				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_MED_07.html");
//				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_MED_07.html");
//			}else if(sFinancelType.equals("040")){
//				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_ED_07.html");
//				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_ED_07.html");
//			}else{
//				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/Blank_000.html");
//				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/Blank_000.html");
//			}
//		}
//		catch(Exception e){
//			throw new Exception("û���ҵ�ģ���ļ���" + e.toString());
//		}
//	}
	
	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		opinion4 = " ";
		opinion5 = " ";
		opinion6 = " ";
		opinion7 = " ";
		opinion8 = " ";
		return true;
	}

//	public String getReportType(String CustomerID) throws JBOException{
//		String sReturn = "";
//		
//		FinanceDataManager fdm = new FinanceDataManager();
//		CustomerFSRecord cfs = fdm.getNewestReport(CustomerID);
//		if(cfs != null){
//			sReturn = cfs.getFinanceBelong();
//		}else {
//			sReturn = "";
//		}
//		return sReturn;
//	}
	
	public DocExtClass getExtobjc0() {
		return extobjc0;
	}

	public void setExtobjc0(DocExtClass extobjc0) {
		this.extobjc0 = extobjc0;
	}

	public DocExtClass getExtobjc1() {
		return extobjc1;
	}

	public void setExtobjc1(DocExtClass extobjc1) {
		this.extobjc1 = extobjc1;
	}

	public DocExtClass getExtobjc2() {
		return extobjc2;
	}

	public void setExtobjc2(DocExtClass extobjc2) {
		this.extobjc2 = extobjc2;
	}

	public DocExtClass getExtobjc4() {
		return extobjc4;
	}

	public void setExtobjc4(DocExtClass extobjc4) {
		this.extobjc4 = extobjc4;
	}

	public DocExtClass getExtobjc6() {
		return extobjc6;
	}

	public void setExtobjc6(DocExtClass extobjc6) {
		this.extobjc6 = extobjc6;
	}

	public DocExtClass getExtobjc7() {
		return extobjc7;
	}

	public void setExtobjc7(DocExtClass extobjc7) {
		this.extobjc7 = extobjc7;
	}

	public DocExtClass getExtobjc8() {
		return extobjc8;
	}

	public void setExtobjc8(DocExtClass extobjc8) {
		this.extobjc8 = extobjc8;
	}

	public DocExtClass getExtobjc9() {
		return extobjc9;
	}

	public void setExtobjc9(DocExtClass extobjc9) {
		this.extobjc9 = extobjc9;
	}

	public DocExtClass getExtobjc10() {
		return extobjc10;
	}

	public void setExtobjc10(DocExtClass extobjc10) {
		this.extobjc10 = extobjc10;
	}

	public DocExtClass getExtobjc11() {
		return extobjc11;
	}

	public void setExtobjc11(DocExtClass extobjc11) {
		this.extobjc11 = extobjc11;
	}

	public DocExtClass getExtobjc12() {
		return extobjc12;
	}

	public void setExtobjc12(DocExtClass extobjc12) {
		this.extobjc12 = extobjc12;
	}

	public DocExtClass getExtobjc13() {
		return extobjc13;
	}

	public void setExtobjc13(DocExtClass extobjc13) {
		this.extobjc13 = extobjc13;
	}

	public DocExtClass getExtobjc14() {
		return extobjc14;
	}

	public void setExtobjc14(DocExtClass extobjc14) {
		this.extobjc14 = extobjc14;
	}

	public DocExtClass getExtobjc15() {
		return extobjc15;
	}

	public void setExtobjc15(DocExtClass extobjc15) {
		this.extobjc15 = extobjc15;
	}

	public DocExtClass getExtobjc16() {
		return extobjc16;
	}

	public void setExtobjc16(DocExtClass extobjc16) {
		this.extobjc16 = extobjc16;
	}

	public DocExtClass getExtobjc17() {
		return extobjc17;
	}

	public void setExtobjc17(DocExtClass extobjc17) {
		this.extobjc17 = extobjc17;
	}

	public DocExtClass getExtobjc18() {
		return extobjc18;
	}

	public void setExtobjc18(DocExtClass extobjc18) {
		this.extobjc18 = extobjc18;
	}

	public DocExtClass getExtobjc19() {
		return extobjc19;
	}

	public void setExtobjc19(DocExtClass extobjc19) {
		this.extobjc19 = extobjc19;
	}

	public DocExtClass getExtobjc20() {
		return extobjc20;
	}

	public void setExtobjc20(DocExtClass extobjc20) {
		this.extobjc20 = extobjc20;
	}

	public DocExtClass getExtobjc21() {
		return extobjc21;
	}

	public void setExtobjc21(DocExtClass extobjc21) {
		this.extobjc21 = extobjc21;
	}

	public DocExtClass getExtobjc22() {
		return extobjc22;
	}

	public void setExtobjc22(DocExtClass extobjc22) {
		this.extobjc22 = extobjc22;
	}

	public DocExtClass getExtobjc23() {
		return extobjc23;
	}

	public void setExtobjc23(DocExtClass extobjc23) {
		this.extobjc23 = extobjc23;
	}

	public DocExtClass getExtobjc24() {
		return extobjc24;
	}

	public void setExtobjc24(DocExtClass extobjc24) {
		this.extobjc24 = extobjc24;
	}

	public DocExtClass getExtobjc25() {
		return extobjc25;
	}

	public void setExtobjc25(DocExtClass extobjc25) {
		this.extobjc25 = extobjc25;
	}

	public DocExtClass[] getExtobjp() {
		return extobjp;
	}

	public void setExtobjp(DocExtClass[] extobjp) {
		this.extobjp = extobjp;
	}

	public DocExtClass[] getExtobjc26() {
		return extobjc26;
	}

	public void setExtobjc26(DocExtClass[] extobjc26) {
		this.extobjc26 = extobjc26;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}

	public String getOpinion3() {
		return opinion3;
	}

	public void setOpinion3(String opinion3) {
		this.opinion3 = opinion3;
	}

	public String getOpinion4() {
		return opinion4;
	}

	public void setOpinion4(String opinion4) {
		this.opinion4 = opinion4;
	}

	public String getOpinion5() {
		return opinion5;
	}

	public void setOpinion5(String opinion5) {
		this.opinion5 = opinion5;
	}

	public String getOpinion6() {
		return opinion6;
	}

	public void setOpinion6(String opinion6) {
		this.opinion6 = opinion6;
	}

	public String getOpinion7() {
		return opinion7;
	}

	public void setOpinion7(String opinion7) {
		this.opinion7 = opinion7;
	}

	public String getOpinion8() {
		return opinion8;
	}

	public void setOpinion8(String opinion8) {
		this.opinion8 = opinion8;
	}

	public String getTotals() {
		return totals;
	}

	public void setTotals(String totals) {
		this.totals = totals;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}

	public DocExtClass getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass extobj3) {
		this.extobj3 = extobj3;
	}

	public DocExtClass getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass extobj4) {
		this.extobj4 = extobj4;
	}

	public DocExtClass getExtobj5() {
		return extobj5;
	}

	public void setExtobj5(DocExtClass extobj5) {
		this.extobj5 = extobj5;
	}

	public DocExtClass getExtobj6() {
		return extobj6;
	}

	public void setExtobj6(DocExtClass extobj6) {
		this.extobj6 = extobj6;
	}
	public DocExtClass getExtobj7() {
		return extobj7;
	}

	public void setExtobj7(DocExtClass extobj7) {
		this.extobj7 = extobj7;
	}

	public DocExtClass getExtobj8() {
		return extobj8;
	}

	public void setExtobj8(DocExtClass extobj8) {
		this.extobj8 = extobj8;
	}

	public DocExtClass getExtobj9() {
		return extobj9;
	}

	public void setExtobj9(DocExtClass extobj9) {
		this.extobj9 = extobj9;
	}

	public DocExtClass getExtobj10() {
		return extobj10;
	}

	public void setExtobj10(DocExtClass extobj10) {
		this.extobj10 = extobj10;
	}

	public DocExtClass getExtobj11() {
		return extobj11;
	}

	public void setExtobj11(DocExtClass extobj11) {
		this.extobj11 = extobj11;
	}

	public DocExtClass getExtobj12() {
		return extobj12;
	}

	public void setExtobj12(DocExtClass extobj12) {
		this.extobj12 = extobj12;
	}

	public DocExtClass getExtobj13() {
		return extobj13;
	}

	public void setExtobj13(DocExtClass extobj13) {
		this.extobj13 = extobj13;
	}

	public DocExtClass getExtobj14() {
		return extobj14;
	}

	public void setExtobj14(DocExtClass extobj14) {
		this.extobj14 = extobj14;
	}

}

