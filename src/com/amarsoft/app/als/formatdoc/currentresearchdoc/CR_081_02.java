package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.FileInputStream;
import java.io.Serializable;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.CodeManager;

public class CR_081_02 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	//�ʲ���ծ��
	private DocExtClass extobj03;
	private DocExtClass extobjz0;
    private DocExtClass extobjz1;
    private DocExtClass extobjz2;
    private DocExtClass extobjz3;
    private DocExtClass extobjz4;
    private DocExtClass extobjz5;
    private DocExtClass extobjz6;
    private DocExtClass extobjz7;
    private DocExtClass extobjz8;
    private DocExtClass extobjz9;
    private DocExtClass extobjz10;
    private DocExtClass extobjz11;
    private DocExtClass extobjz12;
    private DocExtClass extobjz13;
    private DocExtClass extobjz14;
    private DocExtClass extobjz15;
    private DocExtClass extobjz16;
    private DocExtClass extobjz17;
    private DocExtClass extobjz18;
    private DocExtClass extobjz19;
    private DocExtClass extobjz20;
    private DocExtClass extobjz21;
    private DocExtClass extobjz22;
    private DocExtClass extobjz23;
    private DocExtClass extobjz24;
    private DocExtClass extobjz25;
    private DocExtClass extobjz26;
    private DocExtClass extobjz27;
    private DocExtClass extobjz28;
    private DocExtClass extobjz29;
    private DocExtClass extobjz30;
    private DocExtClass extobjz31;
    private DocExtClass extobjz32;
    private DocExtClass extobjz33;
    private DocExtClass extobjz34;
    private DocExtClass extobjz35;
    private DocExtClass extobjz36;
    private DocExtClass extobjz37;
    private DocExtClass extobjz38;
    private DocExtClass extobjz39;
    private DocExtClass extobjz40;
    private DocExtClass extobjz41;
    private DocExtClass extobjz42;
    private DocExtClass extobjz43;
    private DocExtClass extobjz44;
    private DocExtClass extobjz45;
    private DocExtClass extobjz46;
    private DocExtClass extobjz47;
    private DocExtClass extobjz48;
    private DocExtClass extobjz49;
    private DocExtClass extobjz50;
    private DocExtClass extobjz51;
    private DocExtClass extobjz52;
    private DocExtClass extobjz53;
    private DocExtClass extobjz54;
    private DocExtClass extobjz55;
    private DocExtClass extobjz56;
    private DocExtClass extobjz57;
    private DocExtClass extobjz58;
    private DocExtClass extobjz59;
    private DocExtClass extobjz60;
    private DocExtClass extobjz61;
    private DocExtClass extobjz62;
    private DocExtClass extobjz63;
    private DocExtClass extobjz64;
    private DocExtClass extobjz65;
    private DocExtClass extobjz66;
    private DocExtClass extobjz67;
    private DocExtClass extobjz68;
    private DocExtClass extobjz69;
    private DocExtClass extobjz70;
    private DocExtClass extobjz71;
    private DocExtClass extobjz72;
    private DocExtClass extobjz73;
    private DocExtClass extobjz74;
    private DocExtClass extobjz75;
    private DocExtClass extobjz76;
    private String auditOpinion = "";
    
    //������
	private DocExtClass extobj0;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private DocExtClass extobj3;
    private DocExtClass extobj4;
    private DocExtClass extobj5;
    private DocExtClass extobj6;
    private DocExtClass extobj7;
    private DocExtClass extobj8;
    private DocExtClass extobj9;
    private DocExtClass extobj10;
    private DocExtClass extobj11;
    private DocExtClass extobj12;
    private DocExtClass extobj13;
    private DocExtClass extobj14;
    private DocExtClass extobj15;
    private DocExtClass extobj16;
    private DocExtClass extobj17;
    private DocExtClass extobj18;
    private DocExtClass extobj19;
    private DocExtClass extobj20;
    private DocExtClass extobj21;
    private DocExtClass extobj22;
    private DocExtClass extobj23;
    private DocExtClass extobj24;
    private DocExtClass extobj25;
    private DocExtClass extobj26;
    private DocExtClass extobj27;
    private DocExtClass extobj28;
    private DocExtClass extobj29;
    private DocExtClass extobj30;
    private DocExtClass extobj31;
    private DocExtClass extobj32;
    private DocExtClass extobj33;

    private String opinion1 = "";
    private String opinion2 = "";
    private DocExtClass write1;
    
    private String sFinancelType = "";

	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	String customerID = "";
	public CR_081_02() {
	}

	public boolean initObjectForRead() {
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String guarantyNo = this.getGuarantyNo();	
		if(guarantyNo==null)guarantyNo="";
		extobj03 = new DocExtClass();
		extobjz0 = new DocExtClass();
		extobjz1 = new DocExtClass();
		extobjz2 = new DocExtClass();
		extobjz3 = new DocExtClass();
		extobjz4 = new DocExtClass();
		extobjz5 = new DocExtClass();
		extobjz6 = new DocExtClass();
		extobjz7 = new DocExtClass();
		extobjz8 = new DocExtClass();
		extobjz9 = new DocExtClass();
		extobjz10 = new DocExtClass();
		extobjz11 = new DocExtClass();
		extobjz12 = new DocExtClass();
		extobjz13 = new DocExtClass();
		extobjz14 = new DocExtClass();
		extobjz15 = new DocExtClass();
		extobjz16 = new DocExtClass();
		extobjz17 = new DocExtClass();
		extobjz18 = new DocExtClass();
		extobjz19 = new DocExtClass();
		extobjz20 = new DocExtClass();
		extobjz21 = new DocExtClass();
		extobjz22 = new DocExtClass();
		extobjz23 = new DocExtClass();
		extobjz24 = new DocExtClass();
		extobjz25 = new DocExtClass();
		extobjz26 = new DocExtClass();
		extobjz27 = new DocExtClass();
		extobjz28 = new DocExtClass();
		extobjz29 = new DocExtClass();
		extobjz30 = new DocExtClass();
		extobjz31 = new DocExtClass();
		extobjz32 = new DocExtClass();
		extobjz33 = new DocExtClass();
		extobjz34 = new DocExtClass();
		extobjz35 = new DocExtClass();
		extobjz36 = new DocExtClass();
		extobjz37 = new DocExtClass();
		extobjz38 = new DocExtClass();
		extobjz39 = new DocExtClass();
		extobjz40 = new DocExtClass();
		extobjz41 = new DocExtClass();
		extobjz42 = new DocExtClass();
		extobjz43 = new DocExtClass();
		extobjz44 = new DocExtClass();
		extobjz45 = new DocExtClass();
		extobjz46 = new DocExtClass();
		extobjz47 = new DocExtClass();
		extobjz48 = new DocExtClass();
		extobjz49 = new DocExtClass();
		extobjz50 = new DocExtClass();
		extobjz51 = new DocExtClass();
		extobjz52 = new DocExtClass();
		extobjz53 = new DocExtClass();
		extobjz54 = new DocExtClass();
		extobjz55 = new DocExtClass();
		extobjz56 = new DocExtClass();
		extobjz57 = new DocExtClass();
		extobjz58 = new DocExtClass();
		extobjz59 = new DocExtClass();
		extobjz60 = new DocExtClass();
		extobjz61 = new DocExtClass();
		extobjz62 = new DocExtClass();
		extobjz63 = new DocExtClass();
		extobjz64 = new DocExtClass();
		extobjz65 = new DocExtClass();
		extobjz66 = new DocExtClass();
		extobjz67 = new DocExtClass();
		extobjz68 = new DocExtClass();
		extobjz69 = new DocExtClass();
		extobjz70 = new DocExtClass();
		extobjz71 = new DocExtClass();
		extobjz72 = new DocExtClass();
		extobjz73 = new DocExtClass();
		extobjz74 = new DocExtClass();
		extobjz75 = new DocExtClass();
		extobjz76 = new DocExtClass();
		
		//������
		extobj0 = new DocExtClass();
		extobj1 = new DocExtClass();
		extobj2 = new DocExtClass();
		extobj3 = new DocExtClass();
		extobj4 = new DocExtClass();
		extobj5 = new DocExtClass();
		extobj6 = new DocExtClass();
		extobj7 = new DocExtClass();
		extobj8 = new DocExtClass();
		extobj9 = new DocExtClass();
		extobj10 = new DocExtClass();
		extobj11 = new DocExtClass();
		extobj12 = new DocExtClass();
		extobj13 = new DocExtClass();
		extobj14 = new DocExtClass();
		extobj15 = new DocExtClass();
		extobj16 = new DocExtClass();
		extobj17 = new DocExtClass();
		extobj18 = new DocExtClass();
		extobj19 = new DocExtClass();
		extobj20 = new DocExtClass();
		extobj21 = new DocExtClass();
		extobj22 = new DocExtClass();
		extobj23 = new DocExtClass();
		extobj24 = new DocExtClass();
		extobj25 = new DocExtClass();
		extobj26 = new DocExtClass();
		extobj27 = new DocExtClass();
		extobj28 = new DocExtClass();
		extobj29 = new DocExtClass();
		extobj30 = new DocExtClass();
		extobj31 = new DocExtClass();
		extobj32 = new DocExtClass();
		extobj33 = new DocExtClass();

		
		try {
			if(guarantyNo!=null&& !"".equals(guarantyNo)){
				m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
				bo = q.getSingleResult();
				if(bo != null){
					customerID = bo.getAttribute("COLASSETOWNER").getString();
				}
				
			}
			if(!StringX.isSpace(customerID)){
				sFinancelType = getReportType(customerID);
				FinanceDataManager fdm=new FinanceDataManager();
				CustomerFSRecord cfs=fdm.getNewestReport(customerID);
				CustomerFSRecord yearReport = fdm.getNewYearReport(customerID);
				if(cfs != null){
					extobj03.setAttr1(cfs.getReportDate());
					extobj03.setAttr2(cfs.getReportScope());
					extobj03.setAttr3(CodeManager.getItemName("FinanceBelong",cfs.getFinanceBelong()));
					String sCurrency=cfs.getReportCurrency();
					extobj03.setAttr4(CodeManager.getItemName("Currency", sCurrency));
					extobj03.setAttr9(fdm.isLianXu(customerID));
				}
				if(yearReport!=null){
					extobj03.setAttr5(yearReport.getReportDate());
					extobj03.setAttr6(yearReport.getAuditFlag());
//					extobj03.setAttr7(yearReport.getAuditOffice());
					if(!StringX.isSpace(yearReport.getAuditOffice())&& !yearReport.getAuditOffice().equals("����")){
						extobj03.setAttr7(yearReport.getAuditOffice());
					}else{
						extobj03.setAttr7(yearReport.getAccountAntOffice());
					}
					
					extobj03.setAttr8(yearReport.getAuditOpchoose());
					auditOpinion = yearReport.getAuditOpinion();
					extobj03.setAttr0(yearReport.getReportOpinion());
				}
				if("010".equals(sFinancelType)){
					getNew();
				}else if("020".equals(sFinancelType)){
					getOld();
				}else if("160".equals(sFinancelType)){
					getAssure();
				}else if("030".equals(sFinancelType)){
					getOE();
				}else if("050".equals(sFinancelType)){
					getMED();
				}else if("040".equals(sFinancelType)){
					getED();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = "";
		opinion2 = "";
		write1 = new DocExtClass();
		return true;
	}
	
	public void setModelInputStream()throws Exception{
		//String sFinancelType = "010";//���»��׼��Ϊ��
		
		try{
			if(sFinancelType.equals("010")){//һ����ҵ���˲��񱨱�ģ��(�»��׼��ھ�)
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new_02.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new_02.html");//templateFileName+"_new.html"�ļ�Ҫ����
			}else if(sFinancelType.equals("020")){//һ����ҵ���˲��񱨱�ģ��(�ɻ��׼��ھ�)
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_02.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_02.html");//templateFileName+"_old.html"�ļ�Ҫ����
			}else if(sFinancelType.equals("160")){//������˾���񱨱�ģ��
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_assure_02.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_assure_02.html");
			}else if(sFinancelType.equals("030")){//������ҵ��λ���񱨱�ģ��
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_OE_02.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_OE_02.html");
			}else if(sFinancelType.equals("050")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_MED_02.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_MED_02.html");
			}else if(sFinancelType.equals("040")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_ED_02.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_ED_02.html");
			}
		}
		catch(Exception e){
			throw new Exception("û���ҵ�ģ���ļ���" + e.toString());
		}
	}
	
	public String getReportType(String CustomerID) throws JBOException{
		String sReturn = "";
		
		FinanceDataManager fdm = new FinanceDataManager();
		CustomerFSRecord cfs = fdm.getNewestReport(CustomerID);
		if(cfs != null){
			sReturn = cfs.getFinanceBelong();
		}else {
			sReturn = "";
		}
		return sReturn;
	}

	//������
	public void getED(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
		String reportType = cfs.getFinanceBelong();
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAssetMap(cfs);
			rs = (ReportSubject) reportMap.get("�ֽ�");
			extobj1.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���д��");
			extobj2.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ��Ʊ��");
			extobj3.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ�ռ��ݸ���");
			extobj4.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����");
			extobj5.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����");
			extobj6.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʲ��ϼ�");
			extobj7.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ�");
			extobj8.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʲ�");
			extobj9.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��У����ҵͶ��");
			extobj10.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��������Ͷ��");
			extobj11.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʲ�");
			extobj12.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�ʲ��ϼ�");
			extobj13.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�������");
			extobj14.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ��Ʊ��");
			extobj15.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ�����ݴ��");
			extobj16.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ�ɲ���ר����");
			extobj17.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ��˰��");
			extobj18.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���ܿ���");
			extobj19.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ծ�ϼ�");
			extobj20.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ҵ����");
			extobj21.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���У�һ�����");
			extobj22.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ͷ�ʻ���");
			extobj23.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�̶�����");
			extobj24.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("ר�û���");
			extobj25.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ҵ����");
			extobj26.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��Ӫ����");
			extobj27.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����������");
			extobj28.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���������");
			extobj29.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�������ʲ�");
			extobj30.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("δ�����Ŀ��֧���");
			extobj31.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���ʲ��ϼ�");
			extobj32.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ծ�;��ʲ��ϼ�");
			extobj33.setAttr1(rs.getCol2IntString());
		}
		
		CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
		if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)) {
			if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
			double d1;
			Map reportMap1 = financedata.getAssetMap(cfs1);
			rs = (ReportSubject) reportMap1.get("�ֽ�");
			extobj1.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj1.setAttr6(String.format("%.2f",d1));
			}else {
				extobj1.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���д��");
			extobj2.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj2.setAttr6(String.format("%.2f",d1));
			}else {
				extobj2.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��Ʊ��");
			extobj3.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj3.setAttr6(String.format("%.2f",d1));
			}else {
				extobj3.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ�ռ��ݸ���");
			extobj4.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj4.setAttr6(String.format("%.2f",d1));
			}else {
				extobj4.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����");
			extobj5.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj5.setAttr6(String.format("%.2f",d1));
			}else {
				extobj5.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("����");
			extobj6.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj6.setAttr6(String.format("%.2f",d1));
			}else {
				extobj6.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����ʲ��ϼ�");
			extobj7.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj7.setAttr6(String.format("%.2f",d1));
			}else {
				extobj7.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�̶��ʲ�");
			extobj8.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj8.setAttr6(String.format("%.2f",d1));
			}else {
				extobj8.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����ʲ�");
			extobj9.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj9.setAttr6(String.format("%.2f",d1));
			}else {
				extobj9.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��У����ҵͶ��");
			extobj10.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj10.setAttr6(String.format("%.2f",d1));
			}else {
				extobj10.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��������Ͷ��");
			extobj11.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj11.setAttr6(String.format("%.2f",d1));
			}else {
				extobj11.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����ʲ�");
			extobj12.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj12.setAttr6(String.format("%.2f",d1));
			}else {
				extobj12.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�ʲ��ϼ�");
			extobj13.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj13.setAttr6(String.format("%.2f",d1));
			}else {
				extobj13.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�������");
			extobj14.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj14.setAttr6(String.format("%.2f",d1));
			}else {
				extobj14.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��Ʊ��");
			extobj15.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj15.setAttr6(String.format("%.2f",d1));
			}else {
				extobj15.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ�����ݴ��");
			extobj16.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj16.setAttr6(String.format("%.2f",d1));
			}else {
				extobj16.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ�ɲ���ר����");
			extobj17.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj17.setAttr6(String.format("%.2f",d1));
			}else {
				extobj17.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��˰��");
			extobj18.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj18.setAttr6(String.format("%.2f",d1));
			}else {
				extobj18.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���ܿ���");
			extobj19.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj19.setAttr6(String.format("%.2f",d1));
			}else {
				extobj19.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ծ�ϼ�");
			extobj20.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj20.setAttr6(String.format("%.2f",d1));
			}else {
				extobj20.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ҵ����");
			extobj21.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj21.setAttr6(String.format("%.2f",d1));
			}else {
				extobj21.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���У�һ�����");
			extobj22.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj22.setAttr6(String.format("%.2f",d1));
			}else {
				extobj22.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ͷ�ʻ���");
			extobj23.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj23.setAttr6(String.format("%.2f",d1));
			}else {
				extobj23.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�̶�����");
			extobj24.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj24.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj24.setAttr6(String.format("%.2f",d1));
			}else {
				extobj24.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("ר�û���");
			extobj25.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj25.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj25.setAttr6(String.format("%.2f",d1));
			}else {
				extobj25.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ҵ����");
			extobj26.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj26.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj26.setAttr6(String.format("%.2f",d1));
			}else {
				extobj26.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��Ӫ����");
			extobj27.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj27.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj27.setAttr6(String.format("%.2f",d1));
			}else {
				extobj27.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����������");
			extobj28.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj28.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj28.setAttr6(String.format("%.2f",d1));
			}else {
				extobj28.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���������");
			extobj29.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj29.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj29.setAttr6(String.format("%.2f",d1));
			}else {
				extobj29.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�������ʲ�");
			extobj30.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj30.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj30.setAttr6(String.format("%.2f",d1));
			}else {
				extobj30.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("δ�����Ŀ��֧���");
			extobj31.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj31.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj31.setAttr6(String.format("%.2f",d1));
			}else {
				extobj31.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���ʲ��ϼ�");
			extobj32.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj32.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj32.setAttr6(String.format("%.2f",d1));
			}else {
				extobj32.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ծ�;��ʲ��ϼ�");
			extobj33.setAttr2(rs.getCol2IntString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj33.getAttr1()!=null){
				d1 = (Double.parseDouble(extobj33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
				extobj33.setAttr6(String.format("%.2f",d1));
			}else {
				extobj33.setAttr6("");
			}
			
		}
		
		CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//����ĩ
		if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
			Map reportMap2 = financedata.getAssetMap(cfs2);
			rs = (ReportSubject) reportMap2.get("�ֽ�");
			extobj1.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("���д��");
			extobj2.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ӧ��Ʊ��");
			extobj3.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ӧ�ռ��ݸ���");
			extobj4.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�����");
			extobj5.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("����");
			extobj6.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�����ʲ��ϼ�");
			extobj7.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�̶��ʲ�");
			extobj8.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�����ʲ�");
			extobj9.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��У����ҵͶ��");
			extobj10.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��������Ͷ��");
			extobj11.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�����ʲ�");
			extobj12.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�ʲ��ϼ�");
			extobj13.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�������");
			extobj14.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ӧ��Ʊ��");
			extobj15.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ӧ�����ݴ��");
			extobj16.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ӧ�ɲ���ר����");
			extobj17.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ӧ��˰��");
			extobj18.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("���ܿ���");
			extobj19.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��ծ�ϼ�");
			extobj20.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��ҵ����");
			extobj21.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("���У�һ�����");
			extobj22.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("Ͷ�ʻ���");
			extobj23.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�̶�����");
			extobj24.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("ר�û���");
			extobj25.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��ҵ����");
			extobj26.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��Ӫ����");
			extobj27.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�����������");
			extobj28.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("���������");
			extobj29.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("�������ʲ�");
			extobj30.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("δ�����Ŀ��֧���");
			extobj31.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("���ʲ��ϼ�");
			extobj32.setAttr3(rs.getCol2IntString());
			rs = (ReportSubject) reportMap2.get("��ծ�;��ʲ��ϼ�");
			extobj33.setAttr3(rs.getCol2IntString());
		}
		
		CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//������ĩ
		if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs3);
			rs = (ReportSubject) reportMap3.get("�ֽ�");
			extobj1.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���д��");
			extobj2.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobj3.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ�ռ��ݸ���");
			extobj4.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����");
			extobj5.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("����");
			extobj6.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����ʲ��ϼ�");
			extobj7.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�̶��ʲ�");
			extobj8.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobj9.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��У����ҵͶ��");
			extobj10.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��������Ͷ��");
			extobj11.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobj12.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
			extobj13.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�������");
			extobj14.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobj15.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ�����ݴ��");
			extobj16.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ�ɲ���ר����");
			extobj17.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ��˰��");
			extobj18.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���ܿ���");
			extobj19.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
			extobj20.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobj21.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���У�һ�����");
			extobj22.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ͷ�ʻ���");
			extobj23.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�̶�����");
			extobj24.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("ר�û���");
			extobj25.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobj26.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��Ӫ����");
			extobj27.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����������");
			extobj28.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���������");
			extobj29.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�������ʲ�");
			extobj30.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("δ�����Ŀ��֧���");
			extobj31.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���ʲ��ϼ�");
			extobj32.setAttr4(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ծ�;��ʲ��ϼ�");
			extobj33.setAttr4(rs.getCol2IntString());
		}	
		
		CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//������ĩ
		if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs4);
			rs = (ReportSubject) reportMap3.get("�ֽ�");
			extobj1.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���д��");
			extobj2.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobj3.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ�ռ��ݸ���");
			extobj4.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����");
			extobj5.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("����");
			extobj6.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����ʲ��ϼ�");
			extobj7.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�̶��ʲ�");
			extobj8.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobj9.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��У����ҵͶ��");
			extobj10.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��������Ͷ��");
			extobj11.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobj12.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
			extobj13.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�������");
			extobj14.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobj15.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ�����ݴ��");
			extobj16.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ�ɲ���ר����");
			extobj17.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ӧ��˰��");
			extobj18.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���ܿ���");
			extobj19.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
			extobj20.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobj21.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���У�һ�����");
			extobj22.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("Ͷ�ʻ���");
			extobj23.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�̶�����");
			extobj24.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("ר�û���");
			extobj25.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobj26.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��Ӫ����");
			extobj27.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�����������");
			extobj28.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���������");
			extobj29.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("�������ʲ�");
			extobj30.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("δ�����Ŀ��֧���");
			extobj31.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("���ʲ��ϼ�");
			extobj32.setAttr5(rs.getCol2IntString());
			rs = (ReportSubject) reportMap3.get("��ծ�;��ʲ��ϼ�");
			extobj33.setAttr5(rs.getCol2IntString());
		}	
	
	}
	
	public void getOld(){
		//�ɻ��׼�򱨱�
		String reportType = "";
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
		if(cfs != null){
			reportType = cfs.getFinanceBelong();
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAllSubject(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("101");//�����ʽ�
				if(rs!=null){
					extobjz1.setAttr1(rs.getCol2IntString());
				}
//				extobjz1.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("102");//����Ͷ��
				if(rs!=null){
					extobjz2.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("104");//��������Ͷ�ʵ���׼��
				if(rs!=null){
					extobjz3.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("106");//����Ͷ�ʾ���
				if(rs!=null){
					extobjz4.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("105");//Ӧ��Ʊ��
				if(rs!=null){
					extobjz5.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("113");//Ӧ�չ���
				if(rs!=null){
					extobjz6.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("111");//Ӧ����Ϣ
				if(rs!=null){
					extobjz7.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("107");//Ӧ���˿�
				if(rs!=null){
					extobjz8.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("108");//��������׼��
				if(rs!=null){
					extobjz9.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("112");//Ӧ���˿��
				if(rs!=null){
					extobjz10.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("115");//����Ӧ�տ�
				if(rs!=null){
					extobjz11.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("109");//Ԥ���˿�
				if(rs!=null){
					extobjz12.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("110");//Ӧ�ղ�����
				if(rs!=null){
					extobjz13.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("117");//���
				if(rs!=null){
					extobjz14.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("118");//�����������׼��
				if(rs!=null){
					extobjz15.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("116");//�������
				if(rs!=null){
					extobjz16.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("120");//��̯����
				if(rs!=null){
					extobjz17.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("122");//�����������ʲ�����ʧ
				if(rs!=null){
					extobjz18.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("114");//һ���ڵ��ڵĳ��������ʲ�����ʧ
				if(rs!=null){
					extobjz19.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("121");//���������ʲ�
				if(rs!=null){
					extobjz20.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("123");//�����ʲ��ϼ�
				if(rs!=null){
					extobjz21.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("133");//���ڹ�ȨͶ��
				if(rs!=null){
					extobjz22.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("134");//����ծȨͶ��
				if(rs!=null){
					extobjz23.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("136");//��������Ͷ�ʼ�ֵ׼��(������Ȩ��ծȨ����ֵ׼��)
				if(rs!=null){
					extobjz24.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("138");//����Ͷ�ʾ���
				if(rs!=null){
					extobjz25.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("140");//���У��ϲ��۲�
				if(rs!=null){
					extobjz26.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("142");//�̶��ʲ�ԭ��
				if(rs!=null){
					extobjz27.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("144");//�����ۼ��۾�
				if(rs!=null){
					extobjz28.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("146");//�̶��ʲ���ֵ
				if(rs!=null){
					extobjz29.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("148");//�����̶��ʲ���ֵ׼��
				if(rs!=null){
					extobjz30.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("150");//�̶��ʲ�����
				if(rs!=null){
					extobjz31.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("141");//��������
				if(rs!=null){
					extobjz32.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("139");//�ڽ�����
				if(rs!=null){
					extobjz33.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("143");//�̶��ʲ�����
				if(rs!=null){
					extobjz34.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("189");//������̶��ʲ�����ʧ
				if(rs!=null){
					extobjz35.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("154");//�̶��ʲ��ϼ�
				if(rs!=null){
					extobjz36.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("149");//�����ʲ�
				if(rs!=null){
					extobjz37.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("190");//�����
				if(rs!=null){
					extobjz38.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("155");//���ڴ�̯����
				if(rs!=null){
					extobjz39.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("158");//���������ʲ�
				if(rs!=null){
					extobjz40.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("160");//���μ������ʲ��ϼ�
				if(rs!=null){
					extobjz41.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("157");//����˰�����
				if(rs!=null){
					extobjz42.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("165");//�ʲ��ϼ�
				if(rs!=null){
					extobjz43.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("200");//���ڽ��
				if(rs!=null){
					extobjz44.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("204");//Ӧ��Ʊ��
				if(rs!=null){
					extobjz45.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("206");//Ӧ���˿�
				if(rs!=null){
					extobjz46.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("208");//Ԥ���˿�
				if(rs!=null){
					extobjz47.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("209");//������Ʒ��
				if(rs!=null){
					extobjz48.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("210");//Ӧ������
				if(rs!=null){
					extobjz49.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("211");//Ӧ��������
				if(rs!=null){
					extobjz50.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("216");//Ӧ������
				if(rs!=null){
					extobjz51.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("212");//Ӧ��˰��
				if(rs!=null){
					extobjz52.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("223");//����Ӧ����
				if(rs!=null){
					extobjz53.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("218");//����Ӧ����
				if(rs!=null){
					extobjz54.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("219");//Ԥ�����
				if(rs!=null){
					extobjz55.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("236");//Ԥ�Ƹ�ծ
				if(rs!=null){
					extobjz56.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("220");//һ���ڵ��ڵĳ��ڸ�ծ
				if(rs!=null){
					extobjz57.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("222");//����������ծ
				if(rs!=null){
					extobjz58.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("224");//������ծ�ϼ�
				if(rs!=null){
					extobjz59.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("228");//���ڽ��
				if(rs!=null){
					extobjz60.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("230");//Ӧ��ծȯ
				if(rs!=null){
					extobjz61.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("232");//����Ӧ����
				if(rs!=null){
					extobjz62.setAttr1(rs.getCol2IntString());
				};
				rs = (ReportSubject) reportMap.get("234");//ר��Ӧ����
				if(rs!=null){
					extobjz63.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("235");//�������ڸ�ծ
				if(rs!=null){
					extobjz64.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("237");//���ڸ�ծ�ϼ�
				if(rs!=null){
					extobjz65.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("238");//����˰�����
				if(rs!=null){
					extobjz66.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("246");//��ծ�ϼ�
				if(rs!=null){
					extobjz67.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("264");//�����ɶ�Ȩ��
				if(rs!=null){
					extobjz68.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("250");//ʵ���ʱ�(��ɱ�)����
				if(rs!=null){
					extobjz69.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("252");//�ʱ�����
				if(rs!=null){
					extobjz70.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("256");//ӯ�๫��
				if(rs!=null){
					extobjz71.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("257");//���У����������
				if(rs!=null){
					extobjz72.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("258");//δ��������
				if(rs!=null){
					extobjz73.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("260");//��ұ���������
				if(rs!=null){
					extobjz74.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("266");//������Ȩ��ϼ�
				if(rs!=null){
					extobjz75.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("270");//��ծ��������Ȩ��ϼ�
				if(rs!=null){
					extobjz76.setAttr1(rs.getCol2IntString());
				}

			}
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
			if(cfs1 != null ) {
				if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
				double d1;
				Map reportMap1 = financedata.getAllSubject(cfs1);
				if(reportMap1.size()>0){
					rs = (ReportSubject) reportMap1.get("101");//�����ʽ�
					if(rs!=null){
						extobjz1.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz1.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz1.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("102");//����Ͷ��
					if(rs!=null){
						extobjz2.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz2.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz2.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("104");//��������Ͷ�ʵ���׼��
					if(rs!=null){
						extobjz3.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz3.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz3.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("106");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz4.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz4.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz4.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("105");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz5.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz5.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz5.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("113");//Ӧ�չ���
					if(rs!=null){
						extobjz6.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz6.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz6.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("111");//Ӧ����Ϣ
					if(rs!=null){
						extobjz7.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz7.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz7.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("107");//Ӧ���˿�
					if(rs!=null){
						extobjz8.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz8.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz8.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("108");//��������׼��
					if(rs!=null){
						extobjz9.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz9.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz9.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("112");//Ӧ���˿��
					if(rs!=null){
						extobjz10.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz10.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz10.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("115");//����Ӧ�տ�
					if(rs!=null){
						extobjz11.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz11.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz11.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("109");//Ԥ���˿�
					if(rs!=null){
						extobjz12.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz12.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz12.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("110");//Ӧ�ղ�����
					if(rs!=null){
						extobjz13.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz13.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz13.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("117");//���
					if(rs!=null){
						extobjz14.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz14.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz14.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("118");//�����������׼��
					if(rs!=null){
						extobjz15.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz15.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz15.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("116");//�������
					if(rs!=null){
						extobjz16.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz16.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz16.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("120");//��̯����
					if(rs!=null){
						extobjz17.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz17.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz17.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("122");//�����������ʲ�����ʧ
					if(rs!=null){
						extobjz18.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz18.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz18.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("114");//һ���ڵ��ڵĳ��������ʲ�����ʧ
					if(rs!=null){
						extobjz19.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz19.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz19.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("121");//���������ʲ�
					if(rs!=null){
						extobjz20.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz20.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz20.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("123");//�����ʲ��ϼ�
					if(rs!=null){
						extobjz21.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz21.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz21.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("133");//���ڹ�ȨͶ��
					if(rs!=null){
						extobjz22.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz22.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz22.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("134");//����ծȨͶ��
					if(rs!=null){
						extobjz23.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz23.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz23.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("136");//��������Ͷ�ʼ�ֵ׼��(������Ȩ��ծȨ����ֵ׼��)
					if(rs!=null){
						extobjz24.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz24.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz24.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("138");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz25.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz25.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz25.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("140");//���У��ϲ��۲�
					if(rs!=null){
						extobjz26.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz26.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz26.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("142");//�̶��ʲ�ԭ��
					if(rs!=null){
						extobjz27.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz27.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz27.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("144");//�����ۼ��۾�
					if(rs!=null){
						extobjz28.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz28.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz28.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("146");//�̶��ʲ���ֵ
					if(rs!=null){
						extobjz29.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz29.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz29.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("148");//�����̶��ʲ���ֵ׼��
					if(rs!=null){
						extobjz30.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz30.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz30.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("150");//�̶��ʲ�����
					if(rs!=null){
						extobjz31.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz31.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz31.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("141");//��������
					if(rs!=null){
						extobjz32.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz32.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz32.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("139");//�ڽ�����
					if(rs!=null){
						extobjz33.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz33.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz33.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("143");//�̶��ʲ�����
					if(rs!=null){
						extobjz34.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz34.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz34.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("189");//������̶��ʲ�����ʧ
					if(rs!=null){
						extobjz35.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz35.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz35.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("154");//�̶��ʲ��ϼ�
					if(rs!=null){
						extobjz36.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz36.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz36.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz36.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("149");//�����ʲ�
					if(rs!=null){
						extobjz37.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz37.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz37.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz37.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("190");//�����
					if(rs!=null){
						extobjz38.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz38.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz38.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz38.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("155");//���ڴ�̯����
					if(rs!=null){
						extobjz39.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz39.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz39.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz39.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("158");//���������ʲ�
					if(rs!=null){
						extobjz40.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz40.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz40.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz40.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("160");//���μ������ʲ��ϼ�
					if(rs!=null){
						extobjz41.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz41.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz41.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz41.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("157");//����˰�����
					if(rs!=null){
						extobjz42.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz42.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz42.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz42.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("165");//�ʲ��ϼ�
					if(rs!=null){
						extobjz43.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz43.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz43.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz43.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("200");//���ڽ��
					if(rs!=null){
						extobjz44.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz44.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz44.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz44.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("204");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz45.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz45.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz45.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz45.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("206");//Ӧ���˿�
					if(rs!=null){
						extobjz46.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz46.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz46.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz46.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("208");//Ԥ���˿�
					if(rs!=null){
						extobjz47.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz47.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz47.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz47.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("209");//������Ʒ��
					if(rs!=null){
						extobjz48.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz48.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz48.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz48.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz48.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("210");//Ӧ������
					if(rs!=null){
						extobjz49.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz49.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz49.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz49.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz49.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("211");//Ӧ��������
					if(rs!=null){
						extobjz50.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz50.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz50.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz50.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz50.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("216");//Ӧ������
					if(rs!=null){
						extobjz51.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz51.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz51.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz51.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz51.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("212");//Ӧ��˰��
					if(rs!=null){
						extobjz52.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz52.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz52.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz52.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz52.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("223");//����Ӧ����
					if(rs!=null){
						extobjz53.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz53.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz53.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz53.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz53.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("218");
					if(rs!=null){
						extobjz54.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz54.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz54.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz54.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz54.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("219");
					if(rs!=null){
						extobjz55.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz55.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz55.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz55.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz55.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("236");
					if(rs!=null){
						extobjz56.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz56.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz56.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz56.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz56.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("220");
					if(rs!=null){
						extobjz57.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz57.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz57.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz57.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz57.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("222");
					if(rs!=null){
						extobjz58.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz58.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz58.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz58.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz58.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("224");
					if(rs!=null){
						extobjz59.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz59.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz59.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz59.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz59.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("228");
					if(rs!=null){
						extobjz60.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz60.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz60.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz60.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz60.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("230");
					if(rs!=null){
						extobjz61.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz61.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz61.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz61.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz61.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("232");
					if(rs!=null){
						extobjz62.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz62.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz62.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz62.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz62.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("234");
					if(rs!=null){
						extobjz63.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz63.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz63.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz63.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz63.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("235");
					if(rs!=null){
						extobjz64.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz64.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz64.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz64.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz64.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("237");
					if(rs!=null){
						extobjz65.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz65.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz65.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz65.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz65.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("238");
					if(rs!=null){
						extobjz66.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz66.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz66.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz66.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz66.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("246");
					if(rs!=null){
						extobjz67.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz67.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz67.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz67.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz67.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("264");
					if(rs!=null){
						extobjz68.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz68.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz68.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz68.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz68.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("250");
					if(rs!=null){
						extobjz69.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz69.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz69.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz69.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz69.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("252");
					if(rs!=null){
						extobjz70.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz70.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz70.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz70.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz70.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("256");
					if(rs!=null){
						extobjz71.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz71.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz71.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz71.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz71.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("257");
					if(rs!=null){
						extobjz72.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz72.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz72.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz72.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz72.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("258");
					if(rs!=null){
						extobjz73.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz73.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz73.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz73.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz73.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("260");
					if(rs!=null){
						extobjz74.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz74.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz74.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz74.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz74.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("266");
					if(rs!=null){
						extobjz75.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz75.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz75.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz75.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz75.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap1.get("270");
					if(rs!=null){
						extobjz76.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz76.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjz76.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjz76.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjz76.setAttr6("");
						}
					}

				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//����ĩ
			if(cfs2 != null ){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
				Map reportMap2 = financedata.getAllSubject(cfs2);
				if(reportMap2.size()>0){
					rs = (ReportSubject) reportMap2.get("101");
					if(rs!=null){
						extobjz1.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("102");
					if(rs!=null){
						extobjz2.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("104");//��������Ͷ�ʵ���׼��
					if(rs!=null){
						extobjz3.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("106");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz4.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("105");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz5.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("113");//Ӧ�չ���
					if(rs!=null){
						extobjz6.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("111");//Ӧ����Ϣ
					if(rs!=null){
						extobjz7.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("107");//Ӧ���˿�
					if(rs!=null){
						extobjz8.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("108");//��������׼��
					if(rs!=null){
						extobjz9.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("112");//Ӧ���˿��
					if(rs!=null){
						extobjz10.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("115");//����Ӧ�տ�
					if(rs!=null){
						extobjz11.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("109");//Ԥ���˿�
					if(rs!=null){
						extobjz12.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("110");//Ӧ�ղ�����
					if(rs!=null){
						extobjz13.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("117");//���
					if(rs!=null){
						extobjz14.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("118");//�����������׼��
					if(rs!=null){
						extobjz15.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("116");//�������
					if(rs!=null){
						extobjz16.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("120");//��̯����
					if(rs!=null){
						extobjz17.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("122");//�����������ʲ�����ʧ
					if(rs!=null){
						extobjz18.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("114");//һ���ڵ��ڵĳ��������ʲ�����ʧ
					if(rs!=null){
						extobjz19.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("121");//���������ʲ�
					if(rs!=null){
						extobjz20.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("123");//�����ʲ��ϼ�
					if(rs!=null){
						extobjz21.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("133");//���ڹ�ȨͶ��
					if(rs!=null){
						extobjz22.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("134");//����ծȨͶ��
					if(rs!=null){
						extobjz23.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("136");//��������Ͷ�ʼ�ֵ׼��(������Ȩ��ծȨ����ֵ׼��)
					if(rs!=null){
						extobjz24.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("138");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz25.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("140");//���У��ϲ��۲�
					if(rs!=null){
						extobjz26.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("142");//�̶��ʲ�ԭ��
					if(rs!=null){
						extobjz27.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("144");//�����ۼ��۾�
					if(rs!=null){
						extobjz28.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("146");//�̶��ʲ���ֵ
					if(rs!=null){
						extobjz29.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("148");//�����̶��ʲ���ֵ׼��
					if(rs!=null){
						extobjz30.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("150");//�̶��ʲ�����
					if(rs!=null){
						extobjz31.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("141");//��������
					if(rs!=null){
						extobjz32.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("139");//�ڽ�����
					if(rs!=null){
						extobjz33.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("143");//�̶��ʲ�����
					if(rs!=null){
						extobjz34.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("189");//������̶��ʲ�����ʧ
					if(rs!=null){
						extobjz35.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("154");//�̶��ʲ��ϼ�
					if(rs!=null){
						extobjz36.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("149");//�����ʲ�
					if(rs!=null){
						extobjz37.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("190");//�����
					if(rs!=null){
						extobjz38.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("155");//���ڴ�̯����
					if(rs!=null){
						extobjz39.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("158");//���������ʲ�
					if(rs!=null){
						extobjz40.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("160");//���μ������ʲ��ϼ�
					if(rs!=null){
						extobjz41.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("157");//����˰�����
					if(rs!=null){
						extobjz42.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("165");//�ʲ��ϼ�
					if(rs!=null){
						extobjz43.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("200");//���ڽ��
					if(rs!=null){
						extobjz44.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("204");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz45.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("206");//Ӧ���˿�
					if(rs!=null){
						extobjz46.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("208");//Ԥ���˿�
					if(rs!=null){
						extobjz47.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("209");//������Ʒ��
					if(rs!=null){
						extobjz48.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("210");//Ӧ������
					if(rs!=null){
						extobjz49.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("211");//Ӧ��������
					if(rs!=null){
						extobjz50.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("216");//Ӧ������
					if(rs!=null){
						extobjz51.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("212");//Ӧ��˰��
					if(rs!=null){
						extobjz52.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("223");//����Ӧ����
					if(rs!=null){
						extobjz53.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("218");
					if(rs!=null){
						extobjz54.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("219");
					if(rs!=null){
						extobjz55.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("236");
					if(rs!=null){
						extobjz56.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("220");
					if(rs!=null){
						extobjz57.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("222");
					if(rs!=null){
						extobjz58.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("224");
					if(rs!=null){
						extobjz59.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("228");
					if(rs!=null){
						extobjz60.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("230");
					if(rs!=null){
						extobjz61.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("232");
					if(rs!=null){
						extobjz62.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("234");
					if(rs!=null){
						extobjz63.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("235");
					if(rs!=null){
						extobjz64.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("237");
					if(rs!=null){
						extobjz65.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("238");
					if(rs!=null){
						extobjz66.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("246");
					if(rs!=null){
						extobjz67.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("264");
					if(rs!=null){
						extobjz68.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("250");
					if(rs!=null){
						extobjz69.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("252");
					if(rs!=null){
						extobjz70.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("256");
					if(rs!=null){
						extobjz71.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("257");
					if(rs!=null){
						extobjz72.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("258");
					if(rs!=null){
						extobjz73.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("260");
					if(rs!=null){
						extobjz74.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("266");
					if(rs!=null){
						extobjz75.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("270");
					if(rs!=null){
						extobjz76.setAttr3(rs.getCol2IntString());
					}

				}
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//������ĩ
			if(cfs3 != null ){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
				Map reportMap3 = financedata.getAllSubject(cfs3);
				if(reportMap3.size()>0){
					rs = (ReportSubject) reportMap3.get("101");//�����ʽ�
					if(rs!=null){
						extobjz1.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("102");//����Ͷ��
					if(rs!=null){
						extobjz2.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("104");//��������Ͷ�ʵ���׼��
					if(rs!=null){
						extobjz3.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("106");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz4.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("105");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz5.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("113");//Ӧ�չ���
					if(rs!=null){
						extobjz6.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("111");//Ӧ����Ϣ
					if(rs!=null){
						extobjz7.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("107");//Ӧ���˿�
					if(rs!=null){
						extobjz8.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("108");//��������׼��
					if(rs!=null){
						extobjz9.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("112");//Ӧ���˿��
					if(rs!=null){
						extobjz10.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("115");//����Ӧ�տ�
					if(rs!=null){
						extobjz11.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("109");//Ԥ���˿�
					if(rs!=null){
						extobjz12.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("110");//Ӧ�ղ�����
					if(rs!=null){
						extobjz13.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("117");//���
					if(rs!=null){
						extobjz14.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("118");//�����������׼��
					if(rs!=null){
						extobjz15.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("116");//�������
					if(rs!=null){
						extobjz16.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("120");//��̯����
					if(rs!=null){
						extobjz17.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("122");//�����������ʲ�����ʧ
					if(rs!=null){
						extobjz18.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("114");//һ���ڵ��ڵĳ��������ʲ�����ʧ
					if(rs!=null){
						extobjz19.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("121");//���������ʲ�
					if(rs!=null){
						extobjz20.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("123");//�����ʲ��ϼ�
					if(rs!=null){
						extobjz21.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("133");//���ڹ�ȨͶ��
					if(rs!=null){
						extobjz22.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("134");//����ծȨͶ��
					if(rs!=null){
						extobjz23.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("136");//��������Ͷ�ʼ�ֵ׼��(������Ȩ��ծȨ����ֵ׼��)
					if(rs!=null){
						extobjz24.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("138");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz25.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("140");//���У��ϲ��۲�
					if(rs!=null){
						extobjz26.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("142");//�̶��ʲ�ԭ��
					if(rs!=null){
						extobjz27.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("144");//�����ۼ��۾�
					if(rs!=null){
						extobjz28.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("146");//�̶��ʲ���ֵ
					if(rs!=null){
						extobjz29.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("148");//�����̶��ʲ���ֵ׼��
					if(rs!=null){
						extobjz30.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("150");//�̶��ʲ�����
					if(rs!=null){
						extobjz31.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("141");//��������
					if(rs!=null){
						extobjz32.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("139");//�ڽ�����
					if(rs!=null){
						extobjz33.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("143");//�̶��ʲ�����
					if(rs!=null){
						extobjz34.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("189");//������̶��ʲ�����ʧ
					if(rs!=null){
						extobjz35.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("154");//�̶��ʲ��ϼ�
					if(rs!=null){
						extobjz36.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("149");//�����ʲ�
					if(rs!=null){
						extobjz37.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("190");//�����
					if(rs!=null){
						extobjz38.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("155");//���ڴ�̯����
					if(rs!=null){
						extobjz39.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("158");//���������ʲ�
					if(rs!=null){
						extobjz40.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("160");//���μ������ʲ��ϼ�
					if(rs!=null){
						extobjz41.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("157");//����˰�����
					if(rs!=null){
						extobjz42.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("165");//�ʲ��ϼ�
					if(rs!=null){
						extobjz43.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("200");//���ڽ��
					if(rs!=null){
						extobjz44.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("204");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz45.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("206");//Ӧ���˿�
					if(rs!=null){
						extobjz46.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("208");//Ԥ���˿�
					if(rs!=null){
						extobjz47.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("209");//������Ʒ��
					if(rs!=null){
						extobjz48.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("210");//Ӧ������
					if(rs!=null){
						extobjz49.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("211");//Ӧ��������
					if(rs!=null){
						extobjz50.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("216");//Ӧ������
					if(rs!=null){
						extobjz51.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("212");//Ӧ��˰��
					if(rs!=null){
						extobjz52.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("223");//����Ӧ����
					if(rs!=null){
						extobjz53.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("218");
					if(rs!=null){
						extobjz54.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("219");
					if(rs!=null){
						extobjz55.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("236");
					if(rs!=null){
						extobjz56.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("220");
					if(rs!=null){
						extobjz57.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("222");
					if(rs!=null){
						extobjz58.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("224");
					if(rs!=null){
						extobjz59.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("228");
					if(rs!=null){
						extobjz60.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("230");
					if(rs!=null){
						extobjz61.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("232");
					if(rs!=null){
						extobjz62.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("234");
					if(rs!=null){
						extobjz63.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("235");
					if(rs!=null){
						extobjz64.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("237");
					if(rs!=null){
						extobjz65.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("238");
					if(rs!=null){
						extobjz66.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("246");
					if(rs!=null){
						extobjz67.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("264");
					if(rs!=null){
						extobjz68.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("250");
					if(rs!=null){
						extobjz69.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("252");
					if(rs!=null){
						extobjz70.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("256");
					if(rs!=null){
						extobjz71.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("257");
					if(rs!=null){
						extobjz72.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("258");
					if(rs!=null){
						extobjz73.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("260");
					if(rs!=null){
						extobjz74.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("266");
					if(rs!=null){
						extobjz75.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("270");
					if(rs!=null){
						extobjz76.setAttr4(rs.getCol2IntString());
					}

				}
			}	
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//������ĩ
			if(cfs4 != null ){
				if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
				Map reportMap3 = financedata.getAllSubject(cfs4);
				if(reportMap3.size()>0){
					rs = (ReportSubject) reportMap3.get("101");//�����ʽ�
					if(rs!=null){
						extobjz1.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("102");
					if(rs!=null){
						extobjz2.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("104");//��������Ͷ�ʵ���׼��
					if(rs!=null){
						extobjz3.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("106");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz4.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("105");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz5.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("113");//Ӧ�չ���
					if(rs!=null){
						extobjz6.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("111");//Ӧ����Ϣ
					if(rs!=null){
						extobjz7.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("107");//Ӧ���˿�
					if(rs!=null){
						extobjz8.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("108");//��������׼��
					if(rs!=null){
						extobjz9.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("112");//Ӧ���˿��
					if(rs!=null){
						extobjz10.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("115");//����Ӧ�տ�
					if(rs!=null){
						extobjz11.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("109");//Ԥ���˿�
					if(rs!=null){
						extobjz12.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("110");//Ӧ�ղ�����
					if(rs!=null){
						extobjz13.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("117");//���
					if(rs!=null){
						extobjz14.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("118");//�����������׼��
					if(rs!=null){
						extobjz15.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("116");//�������
					if(rs!=null){
						extobjz16.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("120");//��̯����
					if(rs!=null){
						extobjz17.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("122");//�����������ʲ�����ʧ
					if(rs!=null){
						extobjz18.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("114");//һ���ڵ��ڵĳ��������ʲ�����ʧ
					if(rs!=null){
						extobjz19.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("121");//���������ʲ�
					if(rs!=null){
						extobjz20.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("123");//�����ʲ��ϼ�
					if(rs!=null){
						extobjz21.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("133");//���ڹ�ȨͶ��
					if(rs!=null){
						extobjz22.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("134");//����ծȨͶ��
					if(rs!=null){
						extobjz23.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("136");//��������Ͷ�ʼ�ֵ׼��(������Ȩ��ծȨ����ֵ׼��)
					if(rs!=null){
						extobjz24.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("138");//����Ͷ�ʾ���
					if(rs!=null){
						extobjz25.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("140");//���У��ϲ��۲�
					if(rs!=null){
						extobjz26.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("142");//�̶��ʲ�ԭ��
					if(rs!=null){
						extobjz27.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("144");//�����ۼ��۾�
					if(rs!=null){
						extobjz28.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("146");//�̶��ʲ���ֵ
					if(rs!=null){
						extobjz29.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("148");//�����̶��ʲ���ֵ׼��
					if(rs!=null){
						extobjz30.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("150");//�̶��ʲ�����
					if(rs!=null){
						extobjz31.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("141");//��������
					if(rs!=null){
						extobjz32.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("139");//�ڽ�����
					if(rs!=null){
						extobjz33.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("143");//�̶��ʲ�����
					if(rs!=null){
						extobjz34.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("189");//������̶��ʲ�����ʧ
					if(rs!=null){
						extobjz35.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("154");//�̶��ʲ��ϼ�
					if(rs!=null){
						extobjz36.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("149");//�����ʲ�
					if(rs!=null){
						extobjz37.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("190");//�����
					if(rs!=null){
						extobjz38.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("155");//���ڴ�̯����
					if(rs!=null){
						extobjz39.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("158");//���������ʲ�
					if(rs!=null){
						extobjz40.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("160");//���μ������ʲ��ϼ�
					if(rs!=null){
						extobjz41.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("157");//����˰�����
					if(rs!=null){
						extobjz42.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("165");//�ʲ��ϼ�
					if(rs!=null){
						extobjz43.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("200");//���ڽ��
					if(rs!=null){
						extobjz44.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("204");//Ӧ��Ʊ��
					if(rs!=null){
						extobjz45.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("206");//Ӧ���˿�
					if(rs!=null){
						extobjz46.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("208");//Ԥ���˿�
					if(rs!=null){
						extobjz47.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("209");//������Ʒ��
					if(rs!=null){
						extobjz48.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("210");//Ӧ������
					if(rs!=null){
						extobjz49.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("211");//Ӧ��������
					if(rs!=null){
						extobjz50.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("216");//Ӧ������
					if(rs!=null){
						extobjz51.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("212");//Ӧ��˰��
					if(rs!=null){
						extobjz52.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("223");//����Ӧ����
					if(rs!=null){
						extobjz53.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("218");
					if(rs!=null){
						extobjz54.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("219");
					if(rs!=null){
						extobjz55.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("236");
					if(rs!=null){
						extobjz56.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("220");
					if(rs!=null){
						extobjz57.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("222");
					if(rs!=null){
						extobjz58.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("224");
					if(rs!=null){
						extobjz59.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("228");
					if(rs!=null){
						extobjz60.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("230");
					if(rs!=null){
						extobjz61.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("232");
					if(rs!=null){
						extobjz62.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("234");
					if(rs!=null){
						extobjz63.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("235");
					if(rs!=null){
						extobjz64.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("237");
					if(rs!=null){
						extobjz65.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("238");
					if(rs!=null){
						extobjz66.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("246");
					if(rs!=null){
						extobjz67.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("264");
					if(rs!=null){
						extobjz68.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("250");
					if(rs!=null){
						extobjz69.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("252");
					if(rs!=null){
						extobjz70.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("256");
					if(rs!=null){
						extobjz71.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("257");
					if(rs!=null){
						extobjz72.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("258");
					if(rs!=null){
						extobjz73.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("260");
					if(rs!=null){
						extobjz74.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("266");
					if(rs!=null){
						extobjz75.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("270");
					if(rs!=null){
						extobjz76.setAttr5(rs.getCol2IntString());
					}

				}
			}
		}
		
	}
	
	public void getNew(){
		//�»��׼�򱨱�
		String reportType = "";
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
		if(cfs != null){
			reportType = cfs.getFinanceBelong();
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAllSubject(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("101");//�����ʽ�
				if(rs!=null){
					extobjz1.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("103");//�����Խ����ʲ�
				if(rs!=null){
					extobjz2.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("105");//Ӧ��Ʊ��
				if(rs!=null){
					extobjz3.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("107");//Ӧ���˿�
				if(rs!=null){
					extobjz4.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("109");//Ԥ������
				if(rs!=null){
					extobjz5.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("111");//Ӧ����Ϣ
				if(rs!=null){
					extobjz6.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("113");//Ӧ�չ���
				if(rs!=null){
					extobjz7.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("115");//����Ӧ�տ�
				if(rs!=null){
					extobjz8.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("117");//���
				if(rs!=null){
					extobjz9.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("119");//һ���ڵ��ڵķ������ʲ�
				if(rs!=null){
					extobjz10.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("121");//���������ʲ�
				if(rs!=null){
					extobjz11.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("123");//�����ʲ��ϼ�
				if(rs!=null){
					extobjz12.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("127");//�ɹ����۽����ʲ�
				if(rs!=null){
					extobjz13.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("129");//����������Ͷ��
				if(rs!=null){
					extobjz14.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("131");//����Ӧ�տ�
				if(rs!=null){
					extobjz15.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("133");//���ڹ�ȨͶ��
				if(rs!=null){
					extobjz16.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("135");//Ͷ���Է��ز�
				if(rs!=null){
					extobjz17.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("137");//�̶��ʲ�
				if(rs!=null){
					extobjz18.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("139");//�ڽ�����
				if(rs!=null){
					extobjz19.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("141");//��������
				if(rs!=null){
					extobjz20.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("143");//�̶��ʲ�����
				if(rs!=null){
					extobjz21.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("145");//�����������ʲ�
				if(rs!=null){
					extobjz22.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("147");//�����ʲ�
				if(rs!=null){
					extobjz23.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("149");//�����ʲ�
				if(rs!=null){
					extobjz24.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("151");//����֧��
				if(rs!=null){
					extobjz25.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("153");//����
				if(rs!=null){
					extobjz26.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("155");//���ڴ�̯����
				if(rs!=null){
					extobjz27.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("157");//��������˰�ʲ�
				if(rs!=null){
					extobjz28.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("159");//�����������ʲ�
				if(rs!=null){
					extobjz29.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("161");//�������ʲ��ϼ�
				if(rs!=null){
					extobjz30.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("165");//�ʲ��ϼ�
				if(rs!=null){
					extobjz31.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("200");//���ڽ��
				if(rs!=null){
					extobjz32.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("202");//�����Խ��ڸ�ծ
				if(rs!=null){
					extobjz33.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("204");//Ӧ��Ʊ��
				if(rs!=null){
					extobjz34.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("206");//Ӧ���˿�
				if(rs!=null){
					extobjz35.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("208");//Ԥ�տ���
				if(rs!=null){
					extobjz36.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("210");//Ӧ��ְ��н��
				if(rs!=null){
					extobjz37.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("212");//Ӧ��˰��
				if(rs!=null){
					extobjz38.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("214");//Ӧ����Ϣ
				if(rs!=null){
					extobjz39.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("216");//Ӧ������
				if(rs!=null){
					extobjz40.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("218");//����Ӧ����
				if(rs!=null){
					extobjz41.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("220");//һ���ڵ��ڵķ�������ծ
				if(rs!=null){
					extobjz42.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("222");//����������ծ
				if(rs!=null){
					extobjz43.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("224");//������ծ�ϼ�
				if(rs!=null){
					extobjz44.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("228");//���ڽ��
				if(rs!=null){
					extobjz45.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("230");//Ӧ��ծȯ
				if(rs!=null){
					extobjz46.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("232");//����Ӧ����
				if(rs!=null){
					extobjz47.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("234");//ר��Ӧ����
				if(rs!=null){
					extobjz48.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("236");//Ԥ�Ƹ�ծ
				if(rs!=null){
					extobjz49.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("238");//��������˰��ծ
				if(rs!=null){
					extobjz50.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("240");//������������ծ
				if(rs!=null){
					extobjz51.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("242");//��������ծ�ϼ�
				if(rs!=null){
					extobjz52.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("246");//��ծ�ϼ�
				if(rs!=null){
					extobjz53.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("250");//ʵ���ʱ�(��ɱ�)
				if(rs!=null){
					extobjz54.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("252");//�ʱ�����
				if(rs!=null){
					extobjz55.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("254");//��������
				if(rs!=null){
					extobjz56.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("256");//ӯ�๫��
				if(rs!=null){
					extobjz57.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("258");//δ��������
				if(rs!=null){
					extobjz58.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("260");//��ұ���������
				if(rs!=null){
					extobjz59.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("262");//������ĸ��˾������Ȩ��ϼ�
				if(rs!=null){
					extobjz60.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("264");//�����ɶ�Ȩ��
				if(rs!=null){
					extobjz61.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("266");//������Ȩ��ϼ�
				if(rs!=null){
					extobjz62.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("270");//��ծ��������Ȩ��(��ɶ�Ȩ��)�ϼ�
				if(rs!=null){
					extobjz63.setAttr1(rs.getCol2IntString());
				}

			}
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
			if(cfs1 != null ) {
				if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
				double d1;
				Map reportMap1 = financedata.getAllSubject(cfs1);
				if(reportMap1.size()>0){
					rs = (ReportSubject) reportMap1.get("101");
					if(rs!=null){
						extobjz1.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz1.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz1.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("103");
					if(rs!=null){
						extobjz2.setAttr2(rs.getCol2IntString());				
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz2.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz2.setAttr6("");
					}
					}	
					rs = (ReportSubject) reportMap1.get("105");
					if(rs!=null){
						extobjz3.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz3.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz3.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("107");
					if(rs!=null){
						extobjz4.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz4.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz4.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("109");
					if(rs!=null){
						extobjz5.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz5.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz5.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("111");
					if(rs!=null){
						extobjz6.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz6.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz6.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("113");
					if(rs!=null){
						extobjz7.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz7.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz7.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("115");
					if(rs!=null){
						extobjz8.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz8.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz8.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("117");
					if(rs!=null){
						extobjz9.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz9.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz9.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("119");
					if(rs!=null){
						extobjz10.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz10.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz10.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("121");
					if(rs!=null){
						extobjz11.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz11.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz11.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("123");
					if(rs!=null){
						extobjz12.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz12.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz12.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("127");
					if(rs!=null){
						extobjz13.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz13.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz13.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("129");
					if(rs!=null){
						extobjz14.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz14.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz14.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("131");
					if(rs!=null){
						extobjz15.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz15.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz15.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("133");
					if(rs!=null){
						extobjz16.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz16.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz16.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("135");
					if(rs!=null){
						extobjz17.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz17.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz17.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("137");
					if(rs!=null){
						extobjz18.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz18.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz18.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("139");
					if(rs!=null){
						extobjz19.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz19.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz19.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("141");
					if(rs!=null){
						extobjz20.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz20.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz20.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("143");
					if(rs!=null){
						extobjz21.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz21.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz21.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("145");
					if(rs!=null){
						extobjz22.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz22.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz22.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("147");
					if(rs!=null){
						extobjz23.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz23.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz23.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("149");
					if(rs!=null){
						extobjz24.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz24.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz24.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("151");
					if(rs!=null){
						extobjz25.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz25.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz25.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("153");
					if(rs!=null){
						extobjz26.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz26.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz26.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("155");
					if(rs!=null){
						extobjz27.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz27.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz27.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("157");
					if(rs!=null){
						extobjz28.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz28.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz28.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("159");
					if(rs!=null){
						extobjz29.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz29.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz29.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("161");
					if(rs!=null){
						extobjz30.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz30.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz30.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("165");
					if(rs!=null){
						extobjz31.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz31.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz31.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("200");
					if(rs!=null){
						extobjz32.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz32.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz32.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("202");
					if(rs!=null){
						extobjz33.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz33.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz33.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("204");
					if(rs!=null){
						extobjz34.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz34.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz34.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("206");
					if(rs!=null){
						extobjz35.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz35.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz35.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("208");
					if(rs!=null){
						extobjz36.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz36.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz36.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz36.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("210");
					if(rs!=null){
						extobjz37.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz37.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz37.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz37.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("212");
					if(rs!=null){
						extobjz38.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz38.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz38.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz38.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("214");
					if(rs!=null){
						extobjz39.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz39.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz39.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz39.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("216");
					if(rs!=null){
						extobjz40.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz40.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz40.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz40.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("218");
					if(rs!=null){
						extobjz41.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz41.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz41.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz41.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("220");
					if(rs!=null){
						extobjz42.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz42.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz42.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz42.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("222");
					if(rs!=null){
						extobjz43.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz43.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz43.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz43.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("224");
					if(rs!=null){
						extobjz44.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz44.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz44.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz44.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("228");
					if(rs!=null){
						extobjz45.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz45.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz45.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz45.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("230");
					if(rs!=null){
						extobjz46.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz46.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz46.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz46.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("232");
					if(rs!=null){
						extobjz47.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz47.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz47.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz47.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("234");
					if(rs!=null){
						extobjz48.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz48.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz48.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz48.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz48.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("236");
					if(rs!=null){
						extobjz49.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz49.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz49.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz49.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz49.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("238");
					if(rs!=null){
						extobjz50.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz50.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz50.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz50.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz50.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("240");
					if(rs!=null){
						extobjz51.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz51.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz51.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz51.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz51.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("242");
					if(rs!=null){
						extobjz52.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz52.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz52.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz52.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz52.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("246");
					if(rs!=null){
						extobjz53.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz53.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz53.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz53.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz53.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("250");
					if(rs!=null){
						extobjz54.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz54.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz54.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz54.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz54.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("252");
					if(rs!=null){
						extobjz55.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz55.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz55.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz55.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz55.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("254");
					if(rs!=null){
						extobjz56.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz56.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz56.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz56.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz56.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("256");
					if(rs!=null){
						extobjz57.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz57.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz57.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz57.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz57.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("258");
					if(rs!=null){
						extobjz58.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz58.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz58.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz58.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz58.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("260");
					if(rs!=null){
						extobjz59.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz59.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz59.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz59.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz59.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("262");
					if(rs!=null){
						extobjz60.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz60.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz60.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz60.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz60.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("264");
					if(rs!=null){
						extobjz61.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz61.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz61.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz61.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz61.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("266");
					if(rs!=null){
						extobjz62.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz62.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz62.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz62.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz62.setAttr6("");
					}
					}
					rs = (ReportSubject) reportMap1.get("270");
					if(rs!=null){
						extobjz63.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz63.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjz63.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjz63.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjz63.setAttr6("");
					}
					}

				}
			}
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//����ĩ
			if(cfs2 != null ){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
				Map reportMap2 = financedata.getAllSubject(cfs2);
				if(reportMap2.size()>0){
					rs = (ReportSubject) reportMap2.get("101");
					if(rs!=null){
						extobjz1.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("103");
					if(rs!=null){
						extobjz2.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("105");
					if(rs!=null){
						extobjz3.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("107");
					if(rs!=null){
						extobjz4.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("109");
					if(rs!=null){
						extobjz5.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("111");
					if(rs!=null){
						extobjz6.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("113");
					if(rs!=null){
						extobjz7.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("115");
					if(rs!=null){
						extobjz8.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("117");
					if(rs!=null){
						extobjz9.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("119");
					if(rs!=null){
						extobjz10.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("121");
					if(rs!=null){
						extobjz11.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("123");
					if(rs!=null){
						extobjz12.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("127");
					if(rs!=null){
						extobjz13.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("129");
					if(rs!=null){
						extobjz14.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("131");
					if(rs!=null){
						extobjz15.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("133");
					if(rs!=null){
						extobjz16.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("135");
					if(rs!=null){
						extobjz17.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("137");
					if(rs!=null){
						extobjz18.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("139");
					if(rs!=null){
						extobjz19.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("141");
					if(rs!=null){
						extobjz20.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("143");
					if(rs!=null){
						extobjz21.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("145");
					if(rs!=null){
						extobjz22.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("147");
					if(rs!=null){
						extobjz23.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("149");
					if(rs!=null){
						extobjz24.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("151");
					if(rs!=null){
						extobjz25.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("153");
					if(rs!=null){
						extobjz26.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("155");
					if(rs!=null){
						extobjz27.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("157");
					if(rs!=null){
						extobjz28.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("159");
					if(rs!=null){
						extobjz29.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("161");
					if(rs!=null){
						extobjz30.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("165");
					if(rs!=null){
						extobjz31.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("200");
					if(rs!=null){
						extobjz32.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("202");
					if(rs!=null){
						extobjz33.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("204");
					if(rs!=null){
						extobjz34.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("206");
					if(rs!=null){
						extobjz35.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("208");
					if(rs!=null){
						extobjz36.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("210");
					if(rs!=null){
						extobjz37.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("212");
					if(rs!=null){
						extobjz38.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("214");
					if(rs!=null){
						extobjz39.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("216");
					if(rs!=null){
						extobjz40.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("218");
					if(rs!=null){
						extobjz41.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("220");
					if(rs!=null){
						extobjz42.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("222");
					if(rs!=null){
						extobjz43.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("224");
					if(rs!=null){
						extobjz44.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("228");
					if(rs!=null){
						extobjz45.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("230");
					if(rs!=null){
						extobjz46.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("232");
					if(rs!=null){
						extobjz47.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("234");
					if(rs!=null){
						extobjz48.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("236");
					if(rs!=null){
						extobjz49.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("238");
					if(rs!=null){
						extobjz50.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("240");
					if(rs!=null){
						extobjz51.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("242");
					if(rs!=null){
						extobjz52.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("246");
					if(rs!=null){
						extobjz53.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("250");
					if(rs!=null){
						extobjz54.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("252");
					if(rs!=null){
						extobjz55.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("254");
					if(rs!=null){
						extobjz56.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("256");
					if(rs!=null){
						extobjz57.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("258");
					if(rs!=null){
						extobjz58.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("260");
					if(rs!=null){
						extobjz59.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("262");
					if(rs!=null){
						extobjz60.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("264");
					if(rs!=null){
						extobjz61.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("266");
					if(rs!=null){
						extobjz62.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap2.get("270");
					if(rs!=null){
						extobjz63.setAttr3(rs.getCol2IntString());
					}

				}
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//������ĩ
			if(cfs3 != null ){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
				Map reportMap3 = financedata.getAllSubject(cfs3);
				if(reportMap3.size()>0){
					rs = (ReportSubject) reportMap3.get("101");
					if(rs!=null){
						extobjz1.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("103");
					if(rs!=null){
						extobjz2.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("105");
					if(rs!=null){
						extobjz3.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("107");
					if(rs!=null){
						extobjz4.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("109");
					if(rs!=null){
						extobjz5.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("111");
					if(rs!=null){
						extobjz6.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("113");
					if(rs!=null){
						extobjz7.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("115");
					if(rs!=null){
						extobjz8.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("117");
					if(rs!=null){
						extobjz9.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("119");
					if(rs!=null){
						extobjz10.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("121");
					if(rs!=null){
						extobjz11.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("123");
					if(rs!=null){
						extobjz12.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("127");
					if(rs!=null){
						extobjz13.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("129");
					if(rs!=null){
						extobjz14.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("131");
					if(rs!=null){
						extobjz15.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("133");
					if(rs!=null){
						extobjz16.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("135");
					if(rs!=null){
						extobjz17.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("137");
					if(rs!=null){
						extobjz18.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("139");
					if(rs!=null){
						extobjz19.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("141");
					if(rs!=null){
						extobjz20.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("143");
					if(rs!=null){
						extobjz21.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("145");
					if(rs!=null){
						extobjz22.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("147");
					if(rs!=null){
						extobjz23.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("149");
					if(rs!=null){
						extobjz24.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("151");
					if(rs!=null){
						extobjz25.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("153");
					if(rs!=null){
						extobjz26.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("155");
					if(rs!=null){
						extobjz27.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("157");
					if(rs!=null){
						extobjz28.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("159");
					if(rs!=null){
						extobjz29.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("161");
					if(rs!=null){
						extobjz30.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("165");
					if(rs!=null){
						extobjz31.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("200");
					if(rs!=null){
						extobjz32.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("202");
					if(rs!=null){
						extobjz33.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("204");
					if(rs!=null){
						extobjz34.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("206");
					if(rs!=null){
						extobjz35.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("208");
					if(rs!=null){
						extobjz36.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("210");
					if(rs!=null){
						extobjz37.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("212");
					if(rs!=null){
						extobjz38.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("214");
					if(rs!=null){
						extobjz39.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("216");
					if(rs!=null){
						extobjz40.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("218");
					if(rs!=null){
						extobjz41.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("220");
					if(rs!=null){
						extobjz42.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("222");
					if(rs!=null){
						extobjz43.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("224");
					if(rs!=null){
						extobjz44.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("228");
					if(rs!=null){
						extobjz45.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("230");
					if(rs!=null){
						extobjz46.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("232");
					if(rs!=null){
						extobjz47.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("234");
					if(rs!=null){
						extobjz48.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("236");
					if(rs!=null){
						extobjz49.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("238");
					if(rs!=null){
						extobjz50.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("240");
					if(rs!=null){
						extobjz51.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("242");
					if(rs!=null){
						extobjz52.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("246");
					if(rs!=null){
						extobjz53.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("250");
					if(rs!=null){
						extobjz54.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("252");
					if(rs!=null){
						extobjz55.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("254");
					if(rs!=null){
						extobjz56.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("256");
					if(rs!=null){
						extobjz57.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("258");
					if(rs!=null){
						extobjz58.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("260");
					if(rs!=null){
						extobjz59.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("262");
					if(rs!=null){
						extobjz60.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("264");
					if(rs!=null){
						extobjz61.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("266");
					if(rs!=null){
						extobjz62.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("270");
					if(rs!=null){
						extobjz63.setAttr4(rs.getCol2IntString());
					}

				}
			}	
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//������ĩ
			if(cfs4 != null ){
				if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
				Map reportMap3 = financedata.getAllSubject(cfs4);
				if(reportMap3.size()>0){
					rs = (ReportSubject) reportMap3.get("101");
					if(rs!=null){
						extobjz1.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("103");
					if(rs!=null){
						extobjz2.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("105");
					if(rs!=null){
						extobjz3.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("107");
					if(rs!=null){
						extobjz4.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("109");
					if(rs!=null){
						extobjz5.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("111");
					if(rs!=null){
						extobjz6.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("113");
					if(rs!=null){
						extobjz7.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("115");
					if(rs!=null){
						extobjz8.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("117");
					if(rs!=null){
						extobjz9.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("119");
					if(rs!=null){
						extobjz10.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("121");
					if(rs!=null){
						extobjz11.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("123");
					if(rs!=null){
						extobjz12.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("127");
					if(rs!=null){
						extobjz13.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("129");
					if(rs!=null){
						extobjz14.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("131");
					if(rs!=null){
						extobjz15.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("133");
					if(rs!=null){
						extobjz16.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("135");
					if(rs!=null){
						extobjz17.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("137");
					if(rs!=null){
						extobjz18.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("139");
					if(rs!=null){
						extobjz19.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("141");
					if(rs!=null){
						extobjz20.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("143");
					if(rs!=null){
						extobjz21.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("145");
					if(rs!=null){
						extobjz22.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("147");
					if(rs!=null){
						extobjz23.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("149");
					if(rs!=null){
						extobjz24.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("151");
					if(rs!=null){
						extobjz25.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("153");
					if(rs!=null){
						extobjz26.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("155");
					if(rs!=null){
						extobjz27.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("157");
					if(rs!=null){
						extobjz28.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("159");
					if(rs!=null){
						extobjz29.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("161");
					if(rs!=null){
						extobjz30.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("165");
					if(rs!=null){
						extobjz31.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("200");
					if(rs!=null){
						extobjz32.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("202");
					if(rs!=null){
						extobjz33.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("204");
					if(rs!=null){
						extobjz34.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("206");
					if(rs!=null){
						extobjz35.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("208");
					if(rs!=null){
						extobjz36.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("210");
					if(rs!=null){
						extobjz37.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("212");
					if(rs!=null){
						extobjz38.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("214");
					if(rs!=null){
						extobjz39.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("216");
					if(rs!=null){
						extobjz40.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("218");
					if(rs!=null){
						extobjz41.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("220");
					if(rs!=null){
						extobjz42.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("222");
					if(rs!=null){
						extobjz43.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("224");
					if(rs!=null){
						extobjz44.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("228");
					if(rs!=null){
						extobjz45.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("230");
					if(rs!=null){
						extobjz46.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("232");
					if(rs!=null){
						extobjz47.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("234");
					if(rs!=null){
						extobjz48.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("236");
					if(rs!=null){
						extobjz49.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("238");
					if(rs!=null){
						extobjz50.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("240");
					if(rs!=null){
						extobjz51.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("242");
					if(rs!=null){
						extobjz52.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("246");
					if(rs!=null){
						extobjz53.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("250");
					if(rs!=null){
						extobjz54.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("252");
					if(rs!=null){
						extobjz55.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("254");
					if(rs!=null){
						extobjz56.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("256");
					if(rs!=null){
						extobjz57.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("258");
					if(rs!=null){
						extobjz58.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("260");
					if(rs!=null){
						extobjz59.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("262");
					if(rs!=null){
						extobjz60.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("264");
					if(rs!=null){
						extobjz61.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("266");
					if(rs!=null){
						extobjz62.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap3.get("270");
					if(rs!=null){
						extobjz63.setAttr5(rs.getCol2IntString());
					}

				}
			}
		}
	}
	
	public void getAssure(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
		String reportType = cfs.getFinanceBelong();
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAssetMap(cfs);
			rs = (ReportSubject) reportMap.get("�����ʽ�");
			extobjz1.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ͷ��");
			extobjz2.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��Ʊ��");
			extobjz3.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ�չ���");
			extobjz4.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ����Ϣ");
			extobjz5.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ�յ�����");
			extobjz6.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ӧ�տ�");
			extobjz7.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ�մ�����");
			extobjz8.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��̯����");
			extobjz9.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����֤��");
			extobjz10.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("һ���ڵ��ڵĳ���ծȯͶ��");
			extobjz11.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���������ʲ�");
			extobjz12.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����ʲ��ϼ�");
			extobjz13.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���ڹ�ȨͶ��");
			extobjz14.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����ծȯͶ��");
			extobjz15.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ͷ�ʺϼ�");
			extobjz16.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ�ԭ��");
			extobjz17.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����ۼ��۾�");
			extobjz18.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ���ֵ");
			extobjz19.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����̶��ʲ���ֵ׼��");
			extobjz20.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ�����");
			extobjz21.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ�����");
			extobjz22.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ��ϼ�");
			extobjz23.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����ʲ�");
			extobjz24.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���ڴ�̯����");
			extobjz25.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ծ�ʲ�");
			extobjz26.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���������ʲ�");
			extobjz27.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����ʲ��������ʲ��ϼ�");
			extobjz28.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�ʲ��ϼ�");
			extobjz29.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���ڽ��");
			extobjz30.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ������");
			extobjz31.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ӧ����");
			extobjz32.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ӧ����");
			extobjz33.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���뱣֤��");
			extobjz34.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ�����ʼ�������");
			extobjz35.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��˰�𼰸���");
			extobjz36.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ԥ�����");
			extobjz37.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����⳥׼��");
			extobjz38.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��������׼��");
			extobjz39.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ԥ�Ƹ�ծ");
			extobjz40.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("һ���ڵ��ڵĳ��ڸ�ծ");
			extobjz41.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����������ծ");
			extobjz42.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("������ծ�ϼ�");
			extobjz43.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���ڽ��");
			extobjz44.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��ծȯ");
			extobjz45.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ӧ����");
			extobjz46.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("ר��Ӧ����");
			extobjz47.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��������׼��");
			extobjz48.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�������ڸ�ծ");
			extobjz49.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���ڸ�ծ�ϼ�");
			extobjz50.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ծ�ϼ�");
			extobjz51.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("ʵ���ʱ�");
			extobjz52.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�ʱ�����");
			extobjz53.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�������ֻ���");
			extobjz54.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("ӯ�๫��");
			extobjz55.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("һ�����׼��");
			extobjz56.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("δ��������");
			extobjz57.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("������Ȩ��ϼ�");
			extobjz58.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ծ��������Ȩ��ϼ�");
			extobjz59.setAttr1(rs.getCol2ValueString());
			
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)) {
				double d1;
				if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
				Map reportMap1 = financedata.getAssetMap(cfs1);
				rs = (ReportSubject) reportMap1.get("�����ʽ�");
				extobjz1.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz1.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz1.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz1.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ͷ��");
				extobjz2.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz2.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz2.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz2.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ��Ʊ��");
				extobjz3.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz3.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz3.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz3.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ�չ���");
				extobjz4.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz4.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz4.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz4.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ����Ϣ");
				extobjz5.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz5.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz5.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz5.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ�յ�����");
				extobjz6.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz6.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz6.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz6.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ�տ�");
				extobjz7.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz7.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz7.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz7.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ�մ�����");
				extobjz8.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz8.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz8.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz8.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��̯����");
				extobjz9.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz9.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz9.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz9.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����֤��");
				extobjz10.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz10.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz10.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz10.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("һ���ڵ��ڵĳ���ծȯͶ��");
				extobjz11.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz11.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz11.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz11.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���������ʲ�");
				extobjz12.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz12.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz12.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz12.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʲ��ϼ�");
				extobjz13.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz13.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz13.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz13.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڹ�ȨͶ��");
				extobjz14.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz14.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz14.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz14.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����ծȯͶ��");
				extobjz15.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz15.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz15.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz15.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ͷ�ʺϼ�");
				extobjz16.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz16.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz16.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz16.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ�ԭ��");
				extobjz17.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz17.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz17.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz17.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ۼ��۾�");
				extobjz18.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz18.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz18.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz18.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ���ֵ");
				extobjz19.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz19.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz19.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz19.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����̶��ʲ���ֵ׼��");
				extobjz20.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz20.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz20.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz20.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ�����");
				extobjz21.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz21.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz21.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz21.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ�����");
				extobjz22.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz22.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz22.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz22.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ��ϼ�");
				extobjz23.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz23.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz23.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz23.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʲ�");
				extobjz24.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz24.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz24.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz24.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڴ�̯����");
				extobjz25.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz25.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz25.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz25.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��ծ�ʲ�");
				extobjz26.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz26.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz26.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz26.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���������ʲ�");
				extobjz27.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz27.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz27.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz27.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʲ��������ʲ��ϼ�");
				extobjz28.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz28.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz28.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz28.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�ʲ��ϼ�");
				extobjz29.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz29.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz29.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz29.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڽ��");
				extobjz30.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz30.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz30.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz30.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ������");
				extobjz31.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz31.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz31.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz31.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ����");
				extobjz32.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz32.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz32.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz32.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ����");
				extobjz33.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz33.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz33.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz33.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���뱣֤��");
				extobjz34.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz34.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz34.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz34.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ�����ʼ�������");
				extobjz35.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz35.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz35.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz35.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ��˰�𼰸���");
				extobjz36.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz36.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz36.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz36.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz36.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ԥ�����");
				extobjz37.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz37.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz37.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz37.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz37.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����⳥׼��");
				extobjz38.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz38.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz38.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz38.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz38.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��������׼��");
				extobjz39.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz39.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz39.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz39.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz39.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ԥ�Ƹ�ծ");
				extobjz40.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz40.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz40.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz40.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz40.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("һ���ڵ��ڵĳ��ڸ�ծ");
				extobjz41.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz41.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz41.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz41.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz41.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����������ծ");
				extobjz42.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz42.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz42.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz42.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz42.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("������ծ�ϼ�");
				extobjz43.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz43.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz43.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz43.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz43.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڽ��");
				extobjz44.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz44.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz44.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz44.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz44.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ��ծȯ");
				extobjz45.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz45.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz45.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz45.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz45.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ����");
				extobjz46.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz46.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz46.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz46.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz46.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("ר��Ӧ����");
				extobjz47.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz47.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz47.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz47.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz47.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��������׼��");
				extobjz48.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz48.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz48.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz48.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz48.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�������ڸ�ծ");
				extobjz49.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz49.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz49.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz49.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz49.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڸ�ծ�ϼ�");
				extobjz50.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz50.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz50.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz50.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz50.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��ծ�ϼ�");
				extobjz51.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz51.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz51.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz51.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz51.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("ʵ���ʱ�");
				extobjz52.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz52.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz52.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz52.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz52.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�ʱ�����");
				extobjz53.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz53.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz53.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz53.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz53.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�������ֻ���");
				extobjz54.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz54.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz54.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz54.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz54.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("ӯ�๫��");
				extobjz55.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz55.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz55.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz55.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz55.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("һ�����׼��");
				extobjz56.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz56.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz56.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz56.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz56.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("δ��������");
				extobjz57.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz57.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz57.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz57.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz57.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("������Ȩ��ϼ�");
				extobjz58.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz58.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz58.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz58.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz58.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��ծ��������Ȩ��ϼ�");
				extobjz59.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz59.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz59.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjz59.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz59.setAttr6("");
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//����ĩ
			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
				Map reportMap2 = financedata.getAssetMap(cfs2);
				rs = (ReportSubject) reportMap2.get("�����ʽ�");
				extobjz1.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����Ͷ��");
				extobjz2.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ��Ʊ��");
				extobjz3.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ�չ���");
				extobjz4.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ����Ϣ");
				extobjz5.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ�յ�����");
				extobjz6.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����Ӧ�տ�");
				extobjz7.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ�մ�����");
				extobjz8.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("��̯����");
				extobjz9.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����֤��");
				extobjz10.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("һ���ڵ��ڵĳ���ծȯͶ��");
				extobjz11.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���������ʲ�");
				extobjz12.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����ʲ��ϼ�");
				extobjz13.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���ڹ�ȨͶ��");
				extobjz14.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����ծȯͶ��");
				extobjz15.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����Ͷ�ʺϼ�");
				extobjz16.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ�ԭ��");
				extobjz17.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����ۼ��۾�");
				extobjz18.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ���ֵ");
				extobjz19.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����̶��ʲ���ֵ׼��");
				extobjz20.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ�����");
				extobjz21.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ�����");
				extobjz22.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ��ϼ�");
				extobjz23.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����ʲ�");
				extobjz24.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���ڴ�̯����");
				extobjz25.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("��ծ�ʲ�");
				extobjz26.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���������ʲ�");
				extobjz27.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����ʲ��������ʲ��ϼ�");
				extobjz28.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�ʲ��ϼ�");
				extobjz29.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���ڽ��");
				extobjz30.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ������");
				extobjz31.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����Ӧ����");
				extobjz32.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����Ӧ����");
				extobjz33.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���뱣֤��");
				extobjz34.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ�����ʼ�������");
				extobjz35.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ��˰�𼰸���");
				extobjz36.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ԥ�����");
				extobjz37.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�����⳥׼��");
				extobjz38.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("��������׼��");
				extobjz39.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ԥ�Ƹ�ծ");
				extobjz40.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("һ���ڵ��ڵĳ��ڸ�ծ");
				extobjz41.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����������ծ");
				extobjz42.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("������ծ�ϼ�");
				extobjz43.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���ڽ��");
				extobjz44.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("Ӧ��ծȯ");
				extobjz45.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("����Ӧ����");
				extobjz46.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("ר��Ӧ����");
				extobjz47.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("��������׼��");
				extobjz48.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�������ڸ�ծ");
				extobjz49.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("���ڸ�ծ�ϼ�");
				extobjz50.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("��ծ�ϼ�");
				extobjz51.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("ʵ���ʱ�");
				extobjz52.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�ʱ�����");
				extobjz53.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("�������ֻ���");
				extobjz54.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("ӯ�๫��");
				extobjz55.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("һ�����׼��");
				extobjz56.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("δ��������");
				extobjz57.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("������Ȩ��ϼ�");
				extobjz58.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap2.get("��ծ��������Ȩ��ϼ�");
				extobjz59.setAttr3(rs.getCol2ValueString());
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//������ĩ
			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
				Map reportMap3 = financedata.getAssetMap(cfs3);
				rs = (ReportSubject) reportMap3.get("�����ʽ�");
				extobjz1.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ͷ��");
				extobjz2.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
				extobjz3.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�չ���");
				extobjz4.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ����Ϣ");
				extobjz5.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�յ�����");
				extobjz6.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ�տ�");
				extobjz7.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�մ�����");
				extobjz8.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��̯����");
				extobjz9.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����֤��");
				extobjz10.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("һ���ڵ��ڵĳ���ծȯͶ��");
				extobjz11.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���������ʲ�");
				extobjz12.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ʲ��ϼ�");
				extobjz13.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڹ�ȨͶ��");
				extobjz14.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����ծȯͶ��");
				extobjz15.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ͷ�ʺϼ�");
				extobjz16.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�ԭ��");
				extobjz17.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ۼ��۾�");
				extobjz18.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ���ֵ");
				extobjz19.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����̶��ʲ���ֵ׼��");
				extobjz20.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�����");
				extobjz21.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�����");
				extobjz22.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ��ϼ�");
				extobjz23.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ʲ�");
				extobjz24.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڴ�̯����");
				extobjz25.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��ծ�ʲ�");
				extobjz26.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���������ʲ�");
				extobjz27.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ʲ��������ʲ��ϼ�");
				extobjz28.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
				extobjz29.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz30.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ������");
				extobjz31.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz32.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz33.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���뱣֤��");
				extobjz34.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�����ʼ�������");
				extobjz35.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ��˰�𼰸���");
				extobjz36.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ԥ�����");
				extobjz37.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����⳥׼��");
				extobjz38.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��������׼��");
				extobjz39.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ԥ�Ƹ�ծ");
				extobjz40.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("һ���ڵ��ڵĳ��ڸ�ծ");
				extobjz41.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����������ծ");
				extobjz42.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("������ծ�ϼ�");
				extobjz43.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz44.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ��ծȯ");
				extobjz45.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz46.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("ר��Ӧ����");
				extobjz47.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��������׼��");
				extobjz48.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�������ڸ�ծ");
				extobjz49.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڸ�ծ�ϼ�");
				extobjz50.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
				extobjz51.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("ʵ���ʱ�");
				extobjz52.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�ʱ�����");
				extobjz53.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�������ֻ���");
				extobjz54.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("ӯ�๫��");
				extobjz55.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("һ�����׼��");
				extobjz56.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("δ��������");
				extobjz57.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("������Ȩ��ϼ�");
				extobjz58.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��ծ��������Ȩ��ϼ�");
				extobjz59.setAttr4(rs.getCol2ValueString());
			}	
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//������ĩ
			if(cfs4 != null  && cfs4.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
				Map reportMap3 = financedata.getAssetMap(cfs4);
				rs = (ReportSubject) reportMap3.get("�����ʽ�");
				extobjz1.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ͷ��");
				extobjz2.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
				extobjz3.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�չ���");
				extobjz4.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ����Ϣ");
				extobjz5.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�յ�����");
				extobjz6.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ�տ�");
				extobjz7.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�մ�����");
				extobjz8.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��̯����");
				extobjz9.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����֤��");
				extobjz10.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("һ���ڵ��ڵĳ���ծȯͶ��");
				extobjz11.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���������ʲ�");
				extobjz12.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ʲ��ϼ�");
				extobjz13.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڹ�ȨͶ��");
				extobjz14.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����ծȯͶ��");
				extobjz15.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ͷ�ʺϼ�");
				extobjz16.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�ԭ��");
				extobjz17.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ۼ��۾�");
				extobjz18.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ���ֵ");
				extobjz19.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����̶��ʲ���ֵ׼��");
				extobjz20.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�����");
				extobjz21.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�����");
				extobjz22.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ��ϼ�");
				extobjz23.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ʲ�");
				extobjz24.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڴ�̯����");
				extobjz25.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��ծ�ʲ�");
				extobjz26.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���������ʲ�");
				extobjz27.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����ʲ��������ʲ��ϼ�");
				extobjz28.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
				extobjz29.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz30.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ������");
				extobjz31.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz32.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz33.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���뱣֤��");
				extobjz34.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ�����ʼ�������");
				extobjz35.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ��˰�𼰸���");
				extobjz36.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ԥ�����");
				extobjz37.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�����⳥׼��");
				extobjz38.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��������׼��");
				extobjz39.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ԥ�Ƹ�ծ");
				extobjz40.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("һ���ڵ��ڵĳ��ڸ�ծ");
				extobjz41.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����������ծ");
				extobjz42.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("������ծ�ϼ�");
				extobjz43.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz44.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("Ӧ��ծȯ");
				extobjz45.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz46.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("ר��Ӧ����");
				extobjz47.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��������׼��");
				extobjz48.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�������ڸ�ծ");
				extobjz49.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("���ڸ�ծ�ϼ�");
				extobjz50.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
				extobjz51.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("ʵ���ʱ�");
				extobjz52.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�ʱ�����");
				extobjz53.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("�������ֻ���");
				extobjz54.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("ӯ�๫��");
				extobjz55.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("һ�����׼��");
				extobjz56.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("δ��������");
				extobjz57.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("������Ȩ��ϼ�");
				extobjz58.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap3.get("��ծ��������Ȩ��ϼ�");
				extobjz59.setAttr5(rs.getCol2ValueString());
			}	
		}
	}
	public void getOE(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
		String reportType = cfs.getFinanceBelong();
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAssetMap(cfs);
			rs = (ReportSubject) reportMap.get("�ֽ�");
			extobjz1.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���д��");
			extobjz2.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��Ʊ��");
			extobjz3.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ���˿�");
			extobjz4.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ԥ���˿�");
			extobjz5.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ӧ�տ�");
			extobjz6.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����");
			extobjz7.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ʒ");
			extobjz8.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ͷ��");
			extobjz9.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ�");
			extobjz10.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����ʲ�");
			extobjz11.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�ڽ�����");
			extobjz12.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�����ʲ�");
			extobjz13.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�ʲ��ϼ�");
			extobjz14.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�������");
			extobjz15.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��Ʊ��");
			extobjz16.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ���˿�");
			extobjz17.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ԥ���ʿ�");
			extobjz18.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("����Ӧ����");
			extobjz19.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��Ԥ���");
			extobjz20.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ�ɲ���ר����");
			extobjz21.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("Ӧ��˰��");
			extobjz22.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("������ծ");
			extobjz23.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ծ�ϼ�");
			extobjz24.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ҵ����");
			extobjz25.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���У�Ͷ�ʻ���");
			extobjz26.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���У�һ�����");
			extobjz27.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�̶�����");
			extobjz28.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("ר�û���");
			extobjz29.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("�������ʲ�");
			extobjz30.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ҵ����");
			extobjz31.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��Ӫ����");
			extobjz32.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("���ʲ��ϼ�");
			extobjz33.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��֧����");
			extobjz34.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("��ծ�����ʲ��ϼ�");
			extobjz35.setAttr1(rs.getCol2ValueString());
		}
		
		CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
		if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)) {
			double d1;
			if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
			Map reportMap1 = financedata.getAssetMap(cfs1);
			rs = (ReportSubject) reportMap1.get("�ֽ�");
			extobjz1.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz1.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz1.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz1.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���д��");
			extobjz2.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz2.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz2.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz2.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��Ʊ��");
			extobjz3.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz3.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz3.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz3.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ���˿�");
			extobjz4.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz4.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz4.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz4.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ԥ���˿�");
			extobjz5.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz5.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz5.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz5.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("����Ӧ�տ�");
			extobjz6.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz6.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz6.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz6.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("����");
			extobjz7.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz7.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz7.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz7.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("����Ʒ");
			extobjz8.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz8.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz8.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz8.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("����Ͷ��");
			extobjz9.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz9.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz9.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz9.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�̶��ʲ�");
			extobjz10.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz10.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz10.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz10.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����ʲ�");
			extobjz11.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz11.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz11.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz11.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�ڽ�����");
			extobjz12.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz12.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz12.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz12.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�����ʲ�");
			extobjz13.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz13.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz13.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz13.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�ʲ��ϼ�");
			extobjz14.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz14.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz14.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz14.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�������");
			extobjz15.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz15.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz15.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz15.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��Ʊ��");
			extobjz16.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz16.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz16.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz16.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ���˿�");
			extobjz17.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz17.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz17.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz17.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ԥ���ʿ�");
			extobjz18.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz18.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz18.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz18.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("����Ӧ����");
			extobjz19.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz19.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz19.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz19.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��Ԥ���");
			extobjz20.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz20.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz20.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz20.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ�ɲ���ר����");
			extobjz21.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz21.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz21.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz21.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("Ӧ��˰��");
			extobjz22.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz22.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz22.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz22.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("������ծ");
			extobjz23.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz23.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz23.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz23.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ծ�ϼ�");
			extobjz24.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz24.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz24.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz24.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ҵ����");
			extobjz25.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz25.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz25.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz25.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���У�Ͷ�ʻ���");
			extobjz26.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz26.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz26.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz26.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���У�һ�����");
			extobjz27.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz27.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz27.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz27.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�̶�����");
			extobjz28.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz28.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz28.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz28.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("ר�û���");
			extobjz29.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz29.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz29.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz29.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("�������ʲ�");
			extobjz30.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz30.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz30.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz30.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ҵ����");
			extobjz31.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz31.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz31.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz31.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��Ӫ����");
			extobjz32.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz32.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz32.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz32.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("���ʲ��ϼ�");
			extobjz33.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz33.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz33.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz33.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��֧����");
			extobjz34.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz34.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz34.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz34.setAttr6("");
			}
			rs = (ReportSubject) reportMap1.get("��ծ�����ʲ��ϼ�");
			extobjz35.setAttr2(rs.getCol2ValueString());
			if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
				d1 = (Double.parseDouble(extobjz35.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
				extobjz35.setAttr6(String.format("%.2f",d1));
			}else {
				extobjz35.setAttr6("");
			}
			
		}
		
		CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//����ĩ
		if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
			Map reportMap2 = financedata.getAssetMap(cfs2);
			rs = (ReportSubject) reportMap2.get("�ֽ�");
			extobjz1.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("���д��");
			extobjz2.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ��Ʊ��");
			extobjz3.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ���˿�");
			extobjz4.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ԥ���˿�");
			extobjz5.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("����Ӧ�տ�");
			extobjz6.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("����");
			extobjz7.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("����Ʒ");
			extobjz8.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("����Ͷ��");
			extobjz9.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�̶��ʲ�");
			extobjz10.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�����ʲ�");
			extobjz11.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�ڽ�����");
			extobjz12.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�����ʲ�");
			extobjz13.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�ʲ��ϼ�");
			extobjz14.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�������");
			extobjz15.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ��Ʊ��");
			extobjz16.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ���˿�");
			extobjz17.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ԥ���ʿ�");
			extobjz18.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("����Ӧ����");
			extobjz19.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ��Ԥ���");
			extobjz20.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ�ɲ���ר����");
			extobjz21.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("Ӧ��˰��");
			extobjz22.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("������ծ");
			extobjz23.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("��ծ�ϼ�");
			extobjz24.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("��ҵ����");
			extobjz25.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("���У�Ͷ�ʻ���");
			extobjz26.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("���У�һ�����");
			extobjz27.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�̶�����");
			extobjz28.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("ר�û���");
			extobjz29.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("�������ʲ�");
			extobjz30.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("��ҵ����");
			extobjz31.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("��Ӫ����");
			extobjz32.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("���ʲ��ϼ�");
			extobjz33.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("��֧����");
			extobjz34.setAttr3(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap2.get("��ծ�����ʲ��ϼ�");
			extobjz35.setAttr3(rs.getCol2ValueString());
		}
		
		CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//������ĩ
		if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs3);
			rs = (ReportSubject) reportMap3.get("�ֽ�");
			extobjz1.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���д��");
			extobjz2.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobjz3.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ���˿�");
			extobjz4.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ԥ���˿�");
			extobjz5.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ӧ�տ�");
			extobjz6.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����");
			extobjz7.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ʒ");
			extobjz8.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ͷ��");
			extobjz9.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�̶��ʲ�");
			extobjz10.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobjz11.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�ڽ�����");
			extobjz12.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobjz13.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
			extobjz14.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�������");
			extobjz15.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobjz16.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ���˿�");
			extobjz17.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ԥ���ʿ�");
			extobjz18.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ӧ����");
			extobjz19.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ԥ���");
			extobjz20.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ�ɲ���ר����");
			extobjz21.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��˰��");
			extobjz22.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("������ծ");
			extobjz23.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
			extobjz24.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobjz25.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���У�Ͷ�ʻ���");
			extobjz26.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���У�һ�����");
			extobjz27.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�̶�����");
			extobjz28.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("ר�û���");
			extobjz29.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�������ʲ�");
			extobjz30.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobjz31.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��Ӫ����");
			extobjz32.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���ʲ��ϼ�");
			extobjz33.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��֧����");
			extobjz34.setAttr4(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ծ�����ʲ��ϼ�");
			extobjz35.setAttr4(rs.getCol2ValueString());
		}	
		
		CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//������ĩ
		if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
			Map reportMap3 = financedata.getAssetMap(cfs4);
			rs = (ReportSubject) reportMap3.get("�ֽ�");
			extobjz1.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���д��");
			extobjz2.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobjz3.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ���˿�");
			extobjz4.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ԥ���˿�");
			extobjz5.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ӧ�տ�");
			extobjz6.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����");
			extobjz7.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ʒ");
			extobjz8.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ͷ��");
			extobjz9.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�̶��ʲ�");
			extobjz10.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobjz11.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�ڽ�����");
			extobjz12.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�����ʲ�");
			extobjz13.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
			extobjz14.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�������");
			extobjz15.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ʊ��");
			extobjz16.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ���˿�");
			extobjz17.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ԥ���ʿ�");
			extobjz18.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("����Ӧ����");
			extobjz19.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��Ԥ���");
			extobjz20.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ�ɲ���ר����");
			extobjz21.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("Ӧ��˰��");
			extobjz22.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("������ծ");
			extobjz23.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
			extobjz24.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobjz25.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���У�Ͷ�ʻ���");
			extobjz26.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���У�һ�����");
			extobjz27.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�̶�����");
			extobjz28.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("ר�û���");
			extobjz29.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("�������ʲ�");
			extobjz30.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ҵ����");
			extobjz31.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��Ӫ����");
			extobjz32.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("���ʲ��ϼ�");
			extobjz33.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��֧����");
			extobjz34.setAttr5(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap3.get("��ծ�����ʲ��ϼ�");
			extobjz35.setAttr5(rs.getCol2ValueString());
		}
	}
	//ҽ���ฺծ�ʲ�����
	public void getMED(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//����
		String reportType = cfs.getFinanceBelong();
		
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobjz0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAssetMap(cfs);
			rs = (ReportSubject) reportMap.get("�ֽ�");
			extobjz1.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���д��");
			extobjz2.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���������ʽ�");
			extobjz3.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʽ�ϼ�");
			extobjz4.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ����Ժ����ҽҩ��");
			extobjz5.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ��ҽ�ƿ�");
			extobjz6.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��������׼��");
			extobjz7.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����Ӧ�տ�");
			extobjz8.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("ҩƷ");
			extobjz9.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����ҩƷ�������");
			extobjz10.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�������");
			extobjz11.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�ڼӹ�����");
			extobjz12.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��̯����");
			extobjz13.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����������ʲ�����ʧ");
			extobjz14.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʲ��ϼ�");
			extobjz15.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����Ͷ��");
			extobjz16.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ�");
			extobjz17.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�ڽ�����");
			extobjz18.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("������̶��ʲ�����ʧ");
			extobjz19.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�̶��ʲ��ϼ�");
			extobjz20.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʲ�");
			extobjz21.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����");
			extobjz22.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�����ʲ�������Ѻϼ�");
			extobjz23.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�ʲ��ϼ�");
			extobjz24.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���ڽ��");
			extobjz25.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ���˿�");
			extobjz26.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ԥ��ҽ�ƿ�");
			extobjz27.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ������");
			extobjz28.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ����ᱣ�Ϸ�");
			extobjz29.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����Ӧ����");
			extobjz30.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ӧ�ɳ��տ�");
			extobjz31.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("Ԥ�����");
			extobjz32.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("������ծ�ϼ�");
			extobjz33.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���ڽ��");
			extobjz34.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����Ӧ����");
			extobjz35.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���ڸ�ծ�ϼ�");
			extobjz36.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ծ�ϼ�");
			extobjz37.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ҵ����");
			extobjz38.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���У�Ͷ�ʻ���");
			extobjz39.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���У�һ�����");
			extobjz40.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�̶�����");
			extobjz41.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("ר�û���");
			extobjz42.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("����ר�������");
			extobjz43.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���������");
			extobjz44.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("�������ʲ�");
			extobjz45.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("���ʲ��ϼ�");
			extobjz46.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("��ծ�;��ʲ��ϼ�");
			extobjz47.setAttr1(rs.getCol2IntString());
			
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//���ȥ��ͬ��
			if(cfs1 != null&& cfs1.getFinanceBelong().equals(reportType)) {
				double d1;
				if(!StringX.isSpace(cfs1.getReportDate()))extobjz0.setAttr2("("+cfs1.getReportDate()+")");
				Map reportMap1 = financedata.getAssetMap(cfs1);
				rs = (ReportSubject) reportMap1.get("�ֽ�");
				extobjz1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz1.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz1.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���д��");
				extobjz2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz2.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz2.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���������ʽ�");
				extobjz3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz3.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz3.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʽ�ϼ�");
				extobjz4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz4.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz4.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ����Ժ����ҽҩ��");
				extobjz5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz5.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz5.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ��ҽ�ƿ�");
				extobjz6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz6.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz6.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��������׼��");
				extobjz7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz7.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz7.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ�տ�");
				extobjz8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz8.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz8.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("ҩƷ");
				extobjz9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz9.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz9.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����ҩƷ�������");
				extobjz10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz10.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz10.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�������");
				extobjz11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz11.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz11.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�ڼӹ�����");
				extobjz12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz12.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz12.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��̯����");
				extobjz13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz13.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz13.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����������ʲ�����ʧ");
				extobjz14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz14.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz14.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʲ��ϼ�");
				extobjz15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz15.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz15.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ͷ��");
				extobjz16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz16.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz16.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ�");
				extobjz17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz17.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz17.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�ڽ�����");
				extobjz18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz18.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz18.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("������̶��ʲ�����ʧ");
				extobjz19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz19.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz19.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶��ʲ��ϼ�");
				extobjz20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz20.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz20.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʲ�");
				extobjz21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz21.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz21.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����");
				extobjz22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz22.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz22.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�����ʲ�������Ѻϼ�");
				extobjz23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz23.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz23.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�ʲ��ϼ�");
				extobjz24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz24.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz24.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڽ��");
				extobjz25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz25.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz25.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ���˿�");
				extobjz26.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz26.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz26.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ԥ��ҽ�ƿ�");
				extobjz27.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz27.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz27.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ������");
				extobjz28.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz28.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz28.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ����ᱣ�Ϸ�");
				extobjz29.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz29.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz29.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ����");
				extobjz30.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz30.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz30.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ӧ�ɳ��տ�");
				extobjz31.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz31.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz31.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("Ԥ�����");
				extobjz32.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz32.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz32.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz32.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("������ծ�ϼ�");
				extobjz33.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz33.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz33.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz33.setAttr6("");
				}
				
				rs = (ReportSubject) reportMap1.get("���ڽ��");
				extobjz34.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz34.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz34.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz34.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����Ӧ����");
				extobjz35.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz35.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz35.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz35.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ڸ�ծ�ϼ�");
				extobjz36.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz36.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz36.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz36.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz36.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��ծ�ϼ�");
				extobjz37.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz37.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz37.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz37.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz37.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��ҵ����");
				extobjz38.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz38.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz38.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz38.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz38.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���У�Ͷ�ʻ���");
				extobjz39.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz39.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz39.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz39.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz39.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���У�һ�����");
				extobjz40.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz40.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz40.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz40.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz40.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�̶�����");
				extobjz41.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz41.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz41.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz41.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz41.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("ר�û���");
				extobjz42.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz42.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz42.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz42.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz42.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("����ר�������");
				extobjz43.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz43.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz43.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz43.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz43.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���������");
				extobjz44.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz44.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz44.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz44.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz44.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("�������ʲ�");
				extobjz45.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz45.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz45.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz45.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz45.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("���ʲ��ϼ�");
				extobjz46.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz46.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz46.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz46.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz46.setAttr6("");
				}
				rs = (ReportSubject) reportMap1.get("��ծ�;��ʲ��ϼ�");
				extobjz47.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjz47.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjz47.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobjz47.setAttr6(String.format("%.2f",d1));
				}else {
					extobjz47.setAttr6("");
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//����ĩ
			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjz0.setAttr3("("+cfs2.getReportDate()+")");
				Map reportMap2 = financedata.getAssetMap(cfs2);
				rs = (ReportSubject) reportMap2.get("�ֽ�");
				extobjz1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���д��");
				extobjz2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���������ʽ�");
				extobjz3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�����ʽ�ϼ�");
				extobjz4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ӧ����Ժ����ҽҩ��");
				extobjz5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ӧ��ҽ�ƿ�");
				extobjz6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("��������׼��");
				extobjz7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("����Ӧ�տ�");
				extobjz8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("ҩƷ");
				extobjz9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("����ҩƷ�������");
				extobjz10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�������");
				extobjz11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�ڼӹ�����");
				extobjz12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("��̯����");
				extobjz13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�����������ʲ�����ʧ");
				extobjz14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�����ʲ��ϼ�");
				extobjz15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("����Ͷ��");
				extobjz16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ�");
				extobjz17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�ڽ�����");
				extobjz18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("������̶��ʲ�����ʧ");
				extobjz19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�̶��ʲ��ϼ�");
				extobjz20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�����ʲ�");
				extobjz21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�����");
				extobjz22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�����ʲ�������Ѻϼ�");
				extobjz23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�ʲ��ϼ�");
				extobjz24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���ڽ��");
				extobjz25.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ӧ���˿�");
				extobjz26.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ԥ��ҽ�ƿ�");
				extobjz27.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ӧ������");
				extobjz28.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ӧ����ᱣ�Ϸ�");
				extobjz29.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("����Ӧ����");
				extobjz30.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ӧ�ɳ��տ�");
				extobjz31.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("Ԥ�����");
				extobjz32.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("������ծ�ϼ�");
				extobjz33.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���ڽ��");
				extobjz34.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("����Ӧ����");
				extobjz35.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���ڸ�ծ�ϼ�");
				extobjz36.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("��ծ�ϼ�");
				extobjz37.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("��ҵ����");
				extobjz38.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���У�Ͷ�ʻ���");
				extobjz39.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���У�һ�����");
				extobjz40.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�̶�����");
				extobjz41.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("ר�û���");
				extobjz42.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("����ר�������");
				extobjz43.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���������");
				extobjz44.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("�������ʲ�");
				extobjz45.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("���ʲ��ϼ�");
				extobjz46.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap2.get("��ծ�;��ʲ��ϼ�");
				extobjz47.setAttr3(rs.getCol2IntString());
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//������ĩ
			if(cfs3 != null&& cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjz0.setAttr4("("+cfs3.getReportDate()+")");
				Map reportMap3 = financedata.getAssetMap(cfs3);
				rs = (ReportSubject) reportMap3.get("�ֽ�");
				extobjz1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���д��");
				extobjz2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���������ʽ�");
				extobjz3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʽ�ϼ�");
				extobjz4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ����Ժ����ҽҩ��");
				extobjz5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ��ҽ�ƿ�");
				extobjz6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��������׼��");
				extobjz7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ӧ�տ�");
				extobjz8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("ҩƷ");
				extobjz9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����ҩƷ�������");
				extobjz10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�������");
				extobjz11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�ڼӹ�����");
				extobjz12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��̯����");
				extobjz13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����������ʲ�����ʧ");
				extobjz14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʲ��ϼ�");
				extobjz15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ͷ��");
				extobjz16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�");
				extobjz17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�ڽ�����");
				extobjz18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("������̶��ʲ�����ʧ");
				extobjz19.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ��ϼ�");
				extobjz20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʲ�");
				extobjz21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����");
				extobjz22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʲ�������Ѻϼ�");
				extobjz23.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
				extobjz24.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz25.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ���˿�");
				extobjz26.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ԥ��ҽ�ƿ�");
				extobjz27.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ������");
				extobjz28.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ����ᱣ�Ϸ�");
				extobjz29.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz30.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ�ɳ��տ�");
				extobjz31.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ԥ�����");
				extobjz32.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("������ծ�ϼ�");
				extobjz33.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz34.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz35.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ڸ�ծ�ϼ�");
				extobjz36.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
				extobjz37.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��ҵ����");
				extobjz38.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���У�Ͷ�ʻ���");
				extobjz39.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���У�һ�����");
				extobjz40.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�̶�����");
				extobjz41.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("ר�û���");
				extobjz42.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����ר�������");
				extobjz43.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���������");
				extobjz44.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�������ʲ�");
				extobjz45.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ʲ��ϼ�");
				extobjz46.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��ծ�;��ʲ��ϼ�");
				extobjz47.setAttr4(rs.getCol2IntString());
			}	
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//������ĩ
			if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs4.getReportDate()))extobjz0.setAttr5("("+cfs4.getReportDate()+")");
				Map reportMap3 = financedata.getAssetMap(cfs4);
				rs = (ReportSubject) reportMap3.get("�ֽ�");
				extobjz1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���д��");
				extobjz2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���������ʽ�");
				extobjz3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʽ�ϼ�");
				extobjz4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ����Ժ����ҽҩ��");
				extobjz5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ��ҽ�ƿ�");
				extobjz6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��������׼��");
				extobjz7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ӧ�տ�");
				extobjz8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("ҩƷ");
				extobjz9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����ҩƷ�������");
				extobjz10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�������");
				extobjz11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�ڼӹ�����");
				extobjz12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��̯����");
				extobjz13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����������ʲ�����ʧ");
				extobjz14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʲ��ϼ�");
				extobjz15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ͷ��");
				extobjz16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ�");
				extobjz17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�ڽ�����");
				extobjz18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("������̶��ʲ�����ʧ");
				extobjz19.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�̶��ʲ��ϼ�");
				extobjz20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʲ�");
				extobjz21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����");
				extobjz22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�����ʲ�������Ѻϼ�");
				extobjz23.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�ʲ��ϼ�");
				extobjz24.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz25.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ���˿�");
				extobjz26.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ԥ��ҽ�ƿ�");
				extobjz27.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ������");
				extobjz28.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ����ᱣ�Ϸ�");
				extobjz29.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz30.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ӧ�ɳ��տ�");
				extobjz31.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("Ԥ�����");
				extobjz32.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("������ծ�ϼ�");
				extobjz33.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ڽ��");
				extobjz34.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����Ӧ����");
				extobjz35.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ڸ�ծ�ϼ�");
				extobjz36.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��ծ�ϼ�");
				extobjz37.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��ҵ����");
				extobjz38.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���У�Ͷ�ʻ���");
				extobjz39.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���У�һ�����");
				extobjz40.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�̶�����");
				extobjz41.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("ר�û���");
				extobjz42.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("����ר�������");
				extobjz43.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���������");
				extobjz44.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("�������ʲ�");
				extobjz45.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("���ʲ��ϼ�");
				extobjz46.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap3.get("��ծ�;��ʲ��ϼ�");
				extobjz47.setAttr5(rs.getCol2IntString());
			}	
		}
	}
	
	public DocExtClass getExtobjz0() {
		return extobjz0;
	}

	public void setExtobjz0(DocExtClass extobjz0) {
		this.extobjz0 = extobjz0;
	}

	public DocExtClass getExtobjz1() {
		return extobjz1;
	}

	public void setExtobjz1(DocExtClass extobjz1) {
		this.extobjz1 = extobjz1;
	}

	public DocExtClass getExtobjz2() {
		return extobjz2;
	}

	public void setExtobjz2(DocExtClass extobjz2) {
		this.extobjz2 = extobjz2;
	}

	public DocExtClass getExtobjz3() {
		return extobjz3;
	}

	public void setExtobjz3(DocExtClass extobjz3) {
		this.extobjz3 = extobjz3;
	}

	public DocExtClass getExtobjz4() {
		return extobjz4;
	}

	public void setExtobjz4(DocExtClass extobjz4) {
		this.extobjz4 = extobjz4;
	}

	public DocExtClass getExtobjz5() {
		return extobjz5;
	}

	public void setExtobjz5(DocExtClass extobjz5) {
		this.extobjz5 = extobjz5;
	}

	public DocExtClass getExtobjz6() {
		return extobjz6;
	}

	public void setExtobjz6(DocExtClass extobjz6) {
		this.extobjz6 = extobjz6;
	}

	public DocExtClass getExtobjz7() {
		return extobjz7;
	}

	public void setExtobjz7(DocExtClass extobjz7) {
		this.extobjz7 = extobjz7;
	}

	public DocExtClass getExtobjz8() {
		return extobjz8;
	}

	public void setExtobjz8(DocExtClass extobjz8) {
		this.extobjz8 = extobjz8;
	}

	public DocExtClass getExtobjz9() {
		return extobjz9;
	}

	public void setExtobjz9(DocExtClass extobjz9) {
		this.extobjz9 = extobjz9;
	}

	public DocExtClass getExtobjz10() {
		return extobjz10;
	}

	public void setExtobjz10(DocExtClass extobjz10) {
		this.extobjz10 = extobjz10;
	}

	public DocExtClass getExtobjz11() {
		return extobjz11;
	}

	public void setExtobjz11(DocExtClass extobjz11) {
		this.extobjz11 = extobjz11;
	}

	public DocExtClass getExtobjz12() {
		return extobjz12;
	}

	public void setExtobjz12(DocExtClass extobjz12) {
		this.extobjz12 = extobjz12;
	}

	public DocExtClass getExtobjz13() {
		return extobjz13;
	}

	public void setExtobjz13(DocExtClass extobjz13) {
		this.extobjz13 = extobjz13;
	}

	public DocExtClass getExtobjz14() {
		return extobjz14;
	}

	public void setExtobjz14(DocExtClass extobjz14) {
		this.extobjz14 = extobjz14;
	}

	public DocExtClass getExtobjz15() {
		return extobjz15;
	}

	public void setExtobjz15(DocExtClass extobjz15) {
		this.extobjz15 = extobjz15;
	}

	public DocExtClass getExtobjz16() {
		return extobjz16;
	}

	public void setExtobjz16(DocExtClass extobjz16) {
		this.extobjz16 = extobjz16;
	}

	public DocExtClass getExtobjz17() {
		return extobjz17;
	}

	public void setExtobjz17(DocExtClass extobjz17) {
		this.extobjz17 = extobjz17;
	}

	public DocExtClass getExtobjz18() {
		return extobjz18;
	}

	public void setExtobjz18(DocExtClass extobjz18) {
		this.extobjz18 = extobjz18;
	}

	public DocExtClass getExtobjz19() {
		return extobjz19;
	}

	public void setExtobjz19(DocExtClass extobjz19) {
		this.extobjz19 = extobjz19;
	}

	public DocExtClass getExtobjz20() {
		return extobjz20;
	}

	public void setExtobjz20(DocExtClass extobjz20) {
		this.extobjz20 = extobjz20;
	}

	public DocExtClass getExtobjz21() {
		return extobjz21;
	}

	public void setExtobjz21(DocExtClass extobjz21) {
		this.extobjz21 = extobjz21;
	}

	public DocExtClass getExtobjz22() {
		return extobjz22;
	}

	public void setExtobjz22(DocExtClass extobjz22) {
		this.extobjz22 = extobjz22;
	}

	public DocExtClass getExtobjz23() {
		return extobjz23;
	}

	public void setExtobjz23(DocExtClass extobjz23) {
		this.extobjz23 = extobjz23;
	}

	public DocExtClass getExtobjz24() {
		return extobjz24;
	}

	public void setExtobjz24(DocExtClass extobjz24) {
		this.extobjz24 = extobjz24;
	}

	public DocExtClass getExtobjz25() {
		return extobjz25;
	}

	public void setExtobjz25(DocExtClass extobjz25) {
		this.extobjz25 = extobjz25;
	}

	public DocExtClass getExtobjz26() {
		return extobjz26;
	}

	public void setExtobjz26(DocExtClass extobjz26) {
		this.extobjz26 = extobjz26;
	}

	public DocExtClass getExtobjz27() {
		return extobjz27;
	}

	public void setExtobjz27(DocExtClass extobjz27) {
		this.extobjz27 = extobjz27;
	}

	public DocExtClass getExtobjz28() {
		return extobjz28;
	}

	public void setExtobjz28(DocExtClass extobjz28) {
		this.extobjz28 = extobjz28;
	}

	public DocExtClass getExtobjz29() {
		return extobjz29;
	}

	public void setExtobjz29(DocExtClass extobjz29) {
		this.extobjz29 = extobjz29;
	}

	public DocExtClass getExtobjz30() {
		return extobjz30;
	}

	public void setExtobjz30(DocExtClass extobjz30) {
		this.extobjz30 = extobjz30;
	}

	public DocExtClass getExtobjz31() {
		return extobjz31;
	}

	public void setExtobjz31(DocExtClass extobjz31) {
		this.extobjz31 = extobjz31;
	}

	public DocExtClass getExtobjz32() {
		return extobjz32;
	}

	public void setExtobjz32(DocExtClass extobjz32) {
		this.extobjz32 = extobjz32;
	}

	public DocExtClass getExtobjz33() {
		return extobjz33;
	}

	public void setExtobjz33(DocExtClass extobjz33) {
		this.extobjz33 = extobjz33;
	}

	public DocExtClass getExtobjz34() {
		return extobjz34;
	}

	public void setExtobjz34(DocExtClass extobjz34) {
		this.extobjz34 = extobjz34;
	}

	public DocExtClass getExtobjz35() {
		return extobjz35;
	}

	public void setExtobjz35(DocExtClass extobjz35) {
		this.extobjz35 = extobjz35;
	}

	public DocExtClass getExtobjz36() {
		return extobjz36;
	}

	public void setExtobjz36(DocExtClass extobjz36) {
		this.extobjz36 = extobjz36;
	}

	public DocExtClass getExtobjz37() {
		return extobjz37;
	}

	public void setExtobjz37(DocExtClass extobjz37) {
		this.extobjz37 = extobjz37;
	}

	public DocExtClass getExtobjz38() {
		return extobjz38;
	}

	public void setExtobjz38(DocExtClass extobjz38) {
		this.extobjz38 = extobjz38;
	}

	public DocExtClass getExtobjz39() {
		return extobjz39;
	}

	public void setExtobjz39(DocExtClass extobjz39) {
		this.extobjz39 = extobjz39;
	}

	public DocExtClass getExtobjz40() {
		return extobjz40;
	}

	public void setExtobjz40(DocExtClass extobjz40) {
		this.extobjz40 = extobjz40;
	}

	public DocExtClass getExtobjz41() {
		return extobjz41;
	}

	public void setExtobjz41(DocExtClass extobjz41) {
		this.extobjz41 = extobjz41;
	}

	public DocExtClass getExtobjz42() {
		return extobjz42;
	}

	public void setExtobjz42(DocExtClass extobjz42) {
		this.extobjz42 = extobjz42;
	}

	public DocExtClass getExtobjz43() {
		return extobjz43;
	}

	public void setExtobjz43(DocExtClass extobjz43) {
		this.extobjz43 = extobjz43;
	}

	public DocExtClass getExtobjz44() {
		return extobjz44;
	}

	public void setExtobjz44(DocExtClass extobjz44) {
		this.extobjz44 = extobjz44;
	}

	public DocExtClass getExtobjz45() {
		return extobjz45;
	}

	public void setExtobjz45(DocExtClass extobjz45) {
		this.extobjz45 = extobjz45;
	}

	public DocExtClass getExtobjz46() {
		return extobjz46;
	}

	public void setExtobjz46(DocExtClass extobjz46) {
		this.extobjz46 = extobjz46;
	}

	public DocExtClass getExtobjz47() {
		return extobjz47;
	}

	public void setExtobjz47(DocExtClass extobjz47) {
		this.extobjz47 = extobjz47;
	}

	public DocExtClass getExtobjz48() {
		return extobjz48;
	}

	public void setExtobjz48(DocExtClass extobjz48) {
		this.extobjz48 = extobjz48;
	}

	public DocExtClass getExtobjz49() {
		return extobjz49;
	}

	public void setExtobjz49(DocExtClass extobjz49) {
		this.extobjz49 = extobjz49;
	}

	public DocExtClass getExtobjz50() {
		return extobjz50;
	}

	public void setExtobjz50(DocExtClass extobjz50) {
		this.extobjz50 = extobjz50;
	}

	public DocExtClass getExtobjz51() {
		return extobjz51;
	}

	public void setExtobjz51(DocExtClass extobjz51) {
		this.extobjz51 = extobjz51;
	}

	public DocExtClass getExtobjz52() {
		return extobjz52;
	}

	public void setExtobjz52(DocExtClass extobjz52) {
		this.extobjz52 = extobjz52;
	}

	public DocExtClass getExtobjz53() {
		return extobjz53;
	}

	public void setExtobjz53(DocExtClass extobjz53) {
		this.extobjz53 = extobjz53;
	}

	public DocExtClass getExtobjz54() {
		return extobjz54;
	}

	public void setExtobjz54(DocExtClass extobjz54) {
		this.extobjz54 = extobjz54;
	}

	public DocExtClass getExtobjz55() {
		return extobjz55;
	}

	public void setExtobjz55(DocExtClass extobjz55) {
		this.extobjz55 = extobjz55;
	}

	public DocExtClass getExtobjz56() {
		return extobjz56;
	}

	public void setExtobjz56(DocExtClass extobjz56) {
		this.extobjz56 = extobjz56;
	}

	public DocExtClass getExtobjz57() {
		return extobjz57;
	}

	public void setExtobjz57(DocExtClass extobjz57) {
		this.extobjz57 = extobjz57;
	}

	public DocExtClass getExtobjz58() {
		return extobjz58;
	}

	public void setExtobjz58(DocExtClass extobjz58) {
		this.extobjz58 = extobjz58;
	}

	public DocExtClass getExtobjz59() {
		return extobjz59;
	}

	public void setExtobjz59(DocExtClass extobjz59) {
		this.extobjz59 = extobjz59;
	}

	public DocExtClass getExtobjz60() {
		return extobjz60;
	}

	public void setExtobjz60(DocExtClass extobjz60) {
		this.extobjz60 = extobjz60;
	}

	public DocExtClass getExtobjz61() {
		return extobjz61;
	}

	public void setExtobjz61(DocExtClass extobjz61) {
		this.extobjz61 = extobjz61;
	}

	public DocExtClass getExtobjz62() {
		return extobjz62;
	}

	public void setExtobjz62(DocExtClass extobjz62) {
		this.extobjz62 = extobjz62;
	}

	public DocExtClass getExtobjz63() {
		return extobjz63;
	}

	public void setExtobjz63(DocExtClass extobjz63) {
		this.extobjz63 = extobjz63;
	}

	public DocExtClass getExtobjz64() {
		return extobjz64;
	}

	public void setExtobjz64(DocExtClass extobjz64) {
		this.extobjz64 = extobjz64;
	}

	public DocExtClass getExtobjz65() {
		return extobjz65;
	}

	public void setExtobjz65(DocExtClass extobjz65) {
		this.extobjz65 = extobjz65;
	}

	public DocExtClass getExtobjz66() {
		return extobjz66;
	}

	public void setExtobjz66(DocExtClass extobjz66) {
		this.extobjz66 = extobjz66;
	}

	public DocExtClass getExtobjz67() {
		return extobjz67;
	}

	public void setExtobjz67(DocExtClass extobjz67) {
		this.extobjz67 = extobjz67;
	}

	public DocExtClass getExtobjz68() {
		return extobjz68;
	}

	public void setExtobjz68(DocExtClass extobjz68) {
		this.extobjz68 = extobjz68;
	}

	public DocExtClass getExtobjz69() {
		return extobjz69;
	}

	public void setExtobjz69(DocExtClass extobjz69) {
		this.extobjz69 = extobjz69;
	}

	public DocExtClass getExtobjz70() {
		return extobjz70;
	}

	public void setExtobjz70(DocExtClass extobjz70) {
		this.extobjz70 = extobjz70;
	}

	public DocExtClass getExtobjz71() {
		return extobjz71;
	}

	public void setExtobjz71(DocExtClass extobjz71) {
		this.extobjz71 = extobjz71;
	}

	public DocExtClass getExtobjz72() {
		return extobjz72;
	}

	public void setExtobjz72(DocExtClass extobjz72) {
		this.extobjz72 = extobjz72;
	}

	public DocExtClass getExtobjz73() {
		return extobjz73;
	}

	public void setExtobjz73(DocExtClass extobjz73) {
		this.extobjz73 = extobjz73;
	}

	public DocExtClass getExtobjz74() {
		return extobjz74;
	}

	public void setExtobjz74(DocExtClass extobjz74) {
		this.extobjz74 = extobjz74;
	}

	public DocExtClass getExtobjz75() {
		return extobjz75;
	}

	public void setExtobjz75(DocExtClass extobjz75) {
		this.extobjz75 = extobjz75;
	}

	public DocExtClass getExtobjz76() {
		return extobjz76;
	}

	public void setExtobjz76(DocExtClass extobjz76) {
		this.extobjz76 = extobjz76;
	}

	public DocExtClass getExtobj03() {
		return extobj03;
	}

	public void setExtobj03(DocExtClass extobj03) {
		this.extobj03 = extobj03;
	}

	public String getAuditOpinion() {
		return auditOpinion;
	}

	public void setAuditOpinion(String auditOpinion) {
		this.auditOpinion = auditOpinion;
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

	public DocExtClass getWrite1() {
		return write1;
	}

	public void setWrite1(DocExtClass write1) {
		this.write1 = write1;
	}
//������
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

	public DocExtClass getExtobj15() {
		return extobj15;
	}

	public void setExtobj15(DocExtClass extobj15) {
		this.extobj15 = extobj15;
	}

	public DocExtClass getExtobj16() {
		return extobj16;
	}

	public void setExtobj16(DocExtClass extobj16) {
		this.extobj16 = extobj16;
	}

	public DocExtClass getExtobj17() {
		return extobj17;
	}

	public void setExtobj17(DocExtClass extobj17) {
		this.extobj17 = extobj17;
	}

	public DocExtClass getExtobj18() {
		return extobj18;
	}

	public void setExtobj18(DocExtClass extobj18) {
		this.extobj18 = extobj18;
	}

	public DocExtClass getExtobj19() {
		return extobj19;
	}

	public void setExtobj19(DocExtClass extobj19) {
		this.extobj19 = extobj19;
	}

	public DocExtClass getExtobj20() {
		return extobj20;
	}

	public void setExtobj20(DocExtClass extobj20) {
		this.extobj20 = extobj20;
	}

	public DocExtClass getExtobj21() {
		return extobj21;
	}

	public void setExtobj21(DocExtClass extobj21) {
		this.extobj21 = extobj21;
	}

	public DocExtClass getExtobj22() {
		return extobj22;
	}

	public void setExtobj22(DocExtClass extobj22) {
		this.extobj22 = extobj22;
	}

	public DocExtClass getExtobj23() {
		return extobj23;
	}

	public void setExtobj23(DocExtClass extobj23) {
		this.extobj23 = extobj23;
	}

	public DocExtClass getExtobj24() {
		return extobj24;
	}

	public void setExtobj24(DocExtClass extobj24) {
		this.extobj24 = extobj24;
	}

	public DocExtClass getExtobj25() {
		return extobj25;
	}

	public void setExtobj25(DocExtClass extobj25) {
		this.extobj25 = extobj25;
	}

	public DocExtClass getExtobj26() {
		return extobj26;
	}

	public void setExtobj26(DocExtClass extobj26) {
		this.extobj26 = extobj26;
	}

	public DocExtClass getExtobj27() {
		return extobj27;
	}

	public void setExtobj27(DocExtClass extobj27) {
		this.extobj27 = extobj27;
	}

	public DocExtClass getExtobj28() {
		return extobj28;
	}

	public void setExtobj28(DocExtClass extobj28) {
		this.extobj28 = extobj28;
	}

	public DocExtClass getExtobj29() {
		return extobj29;
	}

	public void setExtobj29(DocExtClass extobj29) {
		this.extobj29 = extobj29;
	}

	public DocExtClass getExtobj30() {
		return extobj30;
	}

	public void setExtobj30(DocExtClass extobj30) {
		this.extobj30 = extobj30;
	}

	public DocExtClass getExtobj31() {
		return extobj31;
	}

	public void setExtobj31(DocExtClass extobj31) {
		this.extobj31 = extobj31;
	}

	public DocExtClass getExtobj32() {
		return extobj32;
	}

	public void setExtobj32(DocExtClass extobj32) {
		this.extobj32 = extobj32;
	}

	public DocExtClass getExtobj33() {
		return extobj33;
	}

	public void setExtobj33(DocExtClass extobj33) {
		this.extobj33 = extobj33;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
	
	
}

