package com.amarsoft.app.rule;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
 
public class CalRuleData{
	Transaction Sqlca;
	JBOTransaction tx;
	 
	public void calRuleSimpleData(BusinessObjectManager bomanager,BusinessObject applyObject)throws Exception {
		 BusinessObject CI=bomanager.loadBusinessObject("jbo.customer.IND_INFO", "CustomerID",applyObject.getString("CustomerID"));
		 calRuleSimpleData_afterLoan(applyObject);
		 calRuleSimpleData_businessApply(applyObject);
		 calRuleSimpleData_customerInfo(applyObject);
		 calRuleSimpleData_businessIdentity(applyObject);
		 calRuleSimpleData_creditReport(applyObject);
		 calRuleSimpleData_mortgageInfo(applyObject);
		 calRuleSimpleData_odInfo(applyObject);
		 calRuleSimpleData_loanGradeInfo(applyObject);
		 String country=CI.getString("COUNTRY");
		 String birthday=CI.getString("BIRTHDAY");
		 int age=DateHelper.getYears(birthday, DateHelper.getBusinessDate());
		 applyObject.setAttributeValue("totaltenor", applyObject.getString("BusinessTerm"));//��������
		 applyObject.setAttributeValue("age", age);
		  
	}
	//��������Ϣ
	private void calRuleSimpleData_afterLoan(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("projecttype", "01");//������Ŀ����
		applyObject.setAttributeValue("customerrisklevel", "01");//�ͻ����յȼ�
		applyObject.setAttributeValue("taskfrequency", "1");//��������Ƶ��
		applyObject.setAttributeValue("taskfrequencyunit", "05");//��������Ƶ�ʵ�λ
		applyObject.setAttributeValue("taskstoppoint", "02");//����ֹͣ����ʱ��
		applyObject.setAttributeValue("firsttaskmonth", "11");//�״��������ɼ���ڣ��£�
		applyObject.setAttributeValue("firttaskbasetime", "02");//�״���������ʱ��׼ʱ��
		applyObject.setAttributeValue("payway", "01");//�״���������ʱ��׼ʱ��
	}	 

	//��������Ϣ
	private void calRuleSimpleData_businessApply(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("LTP", "50");//
		applyObject.setAttributeValue("LTV", "60");//
		applyObject.setAttributeValue("OD24month", "2");//���ʴ������24�����ۼ����ڴ������������ţ�
		applyObject.setAttributeValue("OD6month", "1");//���ʴ������6�����ۼ����ڴ������������ţ�
		applyObject.setAttributeValue("OtherMonthlyPayment", "2000");//���������������»���
		applyObject.setAttributeValue("currency", "RMB");
		applyObject.setAttributeValue("maxLTVLTP", "40");//�������
		applyObject.setAttributeValue("expiryzl", "01");//��������Ƿ�������Ѻ�ﵽ����
		applyObject.setAttributeValue("amount", 10000);//������
		applyObject.setAttributeValue("extraamount", 500000);//������-�������������ţ�
		applyObject.setAttributeValue("totaltenor", 361);//��������
		applyObject.setAttributeValue("tenorhouseage", 65);//��������+����
		applyObject.setAttributeValue("tenorage", 71);//��������+���������
		applyObject.setAttributeValue("loanpurpose", "101");//������;
		applyObject.setAttributeValue("loanpurpose2", "03");//������;
		applyObject.setAttributeValue("accountstatus", "01");//�����˻�״̬���������ţ�
		applyObject.setAttributeValue("morgagerealestate", "01");//������ʽ�Ƿ�Ϊ������Ѻ
		applyObject.setAttributeValue("NoofRes", "2");//�ڼ��׷��������ף�
		applyObject.setAttributeValue("CLmonth", "01");//�����Ч��
		applyObject.setAttributeValue("citytype1", "01");//�������ڳ������ͣ������ʲ���
		applyObject.setAttributeValue("drawdownmonth", "01");//�ſ����ھ���������������ţ�
		applyObject.setAttributeValue("cartype", "01");//��������
		applyObject.setAttributeValue("relatedML", "01");//�����������Ƿ�Ϊ�������Ҵ���
		applyObject.setAttributeValue("baseaccountrate", "01");//�����˻�������ʣ��޵�Ѻ�������Ѵ��
		applyObject.setAttributeValue("DSRTAV", "01");//�ͻ����������ж���׼
		applyObject.setAttributeValue("customergroup3", "01");//�ͻ����
		applyObject.setAttributeValue("customergroup1", "01");//�ͻ����1
		applyObject.setAttributeValue("customergroup2", "02");//�ͻ����2
		applyObject.setAttributeValue("actualaccountrate", 0.1);//ʵ���˻������
		applyObject.setAttributeValue("paymyself", "01");//�Ƿ���Բ�������֧��
		applyObject.setAttributeValue("guarantee", "");//�Ƿ��з��˱�֤����Ȼ�˱�֤
		applyObject.setAttributeValue("DSR1", "50");//���븺ծ��1
		applyObject.setAttributeValue("DSR2", "");//���븺ծ��2
		applyObject.setAttributeValue("DSR3", "");//���븺ծ��3
		applyObject.setAttributeValue("formeramount", "");//ͬ��ת��ԭ�������
		applyObject.setAttributeValue("landagetenor", "30");//����ʣ������-��������
		applyObject.setAttributeValue("totalUPL2", 100000);//ϵͳ��������޵�Ѻ��ȣ����������޵�Ѻ��
		applyObject.setAttributeValue("totalUPL1", 80000);//ϵͳ��������޵�Ѻ��ȣ��������޵�Ѻ��
		applyObject.setAttributeValue("YRLUPL2", 50000);//ϵͳ������޵�Ѻ��ȣ����������޵�Ѻ���
		applyObject.setAttributeValue("YRLUPL1", 30000);//ϵͳ������޵�Ѻ��ȣ��������޵�Ѻ���
		applyObject.setAttributeValue("relatedML2", "01");//ѺƷ���Ƿ��й������ҷ���
		applyObject.setAttributeValue("product02", "07");//ҵ��Ʒ�֣����ࣩ
		applyObject.setAttributeValue("product01", "01");//ҵ��Ʒ�֣�С�ࣩ
		applyObject.setAttributeValue("promotiontype", "04");//ҵ���Ƽ�����
		applyObject.setAttributeValue("Income", 10000);//�������ܽ��
		applyObject.setAttributeValue("TAV1", "");//�ʲ���ծ��1
		applyObject.setAttributeValue("TAV2", "");//�ʲ���ծ��2
		applyObject.setAttributeValue("assetamount", 1000000);//�ʲ��ܶ�
		
	}	 

	//�ͻ���Ϣ
	private void calRuleSimpleData_customerInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("debtmonthYRD", "3");//���ǿ�������ƽ������������������YRD��
		applyObject.setAttributeValue("employment_country", "CHA");//��λ���ڹ���
		applyObject.setAttributeValue("employmenttype", "02");//��λ����
		applyObject.setAttributeValue("yearofemployment", "01");//��������
		applyObject.setAttributeValue("EmploymentType", "10");//��Ӷ����
		applyObject.setAttributeValue("marriage", "10");//����״��
		applyObject.setAttributeValue("education", "10");//����ˮƽ
		applyObject.setAttributeValue("nation", "CHA");//����˹���
		applyObject.setAttributeValue("domesticforeign", "01");//������ʿ/������ʿ
		applyObject.setAttributeValue("accountdate", "5");//����ʱ�䣨YRD��
		applyObject.setAttributeValue("custtype", "01");//�ͻ�����
		applyObject.setAttributeValue("customertypeYRD", "01");//�ͻ����ͣ�YRD��
		applyObject.setAttributeValue("coapp1y_morgage", "01");//�����������Ƿ�Ϊ������Ѻ��
		
		applyObject.setAttributeValue("age", "26");//����
		applyObject.setAttributeValue("incomeidentification", "01");//����֤�������Ƿ�����
		applyObject.setAttributeValue("industry", "01");//������ҵ
		applyObject.setAttributeValue("debtcardusage", "75");//δ�������ǿ����ʹ���ʣ�YRD��
		applyObject.setAttributeValue("living_status", "01");//�־�ס����״̬
		applyObject.setAttributeValue("sex", "01");//�Ա�
		applyObject.setAttributeValue("IDexpiry", "5");//֤����Ч��
		applyObject.setAttributeValue("position", "03");//ְλ(����)
		applyObject.setAttributeValue("apply_morgage", "01");//���������Ƿ�Ϊ������Ѻ��
		applyObject.setAttributeValue("assetdebt", "01");//�ʲ���ծ���
		
	}

	private void calRuleSimpleData_businessIdentity(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("sharehold", "sharehold");//δ֪��¼
	}
	//������Ϣ
	private void calRuleSimpleData_creditReport(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("CR026", "1");//������ϸ��Ϣ�С���ǰ�����ܶ����0�Ĵ�����
		applyObject.setAttributeValue("CR002", "1");//��ǰ���ڽ��Ϊ1000Ԫ���ϣ���������ǰ��������2�����ϣ������Ĵ�����
		applyObject.setAttributeValue("CR003", "2");//��ǰ���ڽ��Ϊ1000Ԫ���ϣ���������ǰ��������2�����ϣ����������ÿ���
		applyObject.setAttributeValue("CR011", "1");//��ǰ�˻�״̬���֡�ֹ�������ᡢ���ˡ��Ĵ�����
		applyObject.setAttributeValue("CR010", "1");//��ǰ�˻�״̬���֡�ֹ�������ᡢ���ˡ������ÿ���
		applyObject.setAttributeValue("CR001", "01");//�ÿͻ��Ƿ�����Ч���ż�¼
		applyObject.setAttributeValue("CR012", "0");//�����¼�г��֡������˴����������ʵ�ծ���Ĵ�����
		applyObject.setAttributeValue("CR013", "0");//�����¼�г��֡������˴����������ʵ�ծ�������ÿ���
		applyObject.setAttributeValue("CR018", "0");//��12���»����¼�г��֡�1���ۼƴ�������2�Ĵ�����
		applyObject.setAttributeValue("CR017", "1");//��12���»����¼�г��֡�1���ۼƴ�������2�����ÿ���
		applyObject.setAttributeValue("CR009", "0");//��12���»����¼�г��֡�2�����ۼƴ������ڵ���2�Ĵ�����
		applyObject.setAttributeValue("CR008", "0");//��12���»����¼�г��֡�2�����ۼƴ������ڵ���2�����ÿ���
		applyObject.setAttributeValue("CR020", "1");//��12���»����¼�г��֡�2���ۼƴ������ڵ���1�Ĵ�����
		applyObject.setAttributeValue("CR019", "0");//��12���»����¼�г��֡�2���ۼƴ������ڵ���1�����ÿ���
		applyObject.setAttributeValue("CR022", "0");//��24���»����¼�г��֡�2�����ۼƴ������ڡ�2���Ĵ�����
		applyObject.setAttributeValue("CR023", "1");//��24���»����¼�г��֡�2�����ۼƴ������ڡ�2�������ÿ���
		applyObject.setAttributeValue("CR005", "3");//��24���»����¼�г��֡�3�����ۼƴ������ڵ���1�����ÿ���
		applyObject.setAttributeValue("CR004", "2");//��24���»����¼�г��֡�3�����ۼƴ������ڵ���1�������ϸ��Ϣ�С�����������������ڵ��ڡ�3���Ĵ�����
		applyObject.setAttributeValue("CR029", "1");//��24���»����¼�г������֣�1��2��3��4��5��6��7�����ۼƴ������ڵ���1�Ĵ�����
		applyObject.setAttributeValue("CR030", "1");//��24���»����¼�г������֣�1��2��3��4��5��6��7�����ۼƴ������ڵ���1�����ÿ���
		applyObject.setAttributeValue("CR024", "1");//��6���»����¼�г��֡�1�����ۼƴ������ڵ���1�Ĵ�����
		applyObject.setAttributeValue("CR025", "1");//��6���»����¼�г��֡�1�����ۼƴ������ڵ���1�����ÿ���
		applyObject.setAttributeValue("CR006", "1");//��6���»����¼�г��֡�1�����ۼƴ������ڵ���2�Ĵ�����
		applyObject.setAttributeValue("CR007", "1");//��6���»����¼�г��֡�1�����ۼƴ������ڵ���2�����ÿ���
		applyObject.setAttributeValue("CR016", "0");//��6���»����¼�г��֡�1���ۼƴ�������1�Ĵ�����
		applyObject.setAttributeValue("CR015", "0");//��6���»����¼�г��֡�1���ۼƴ�������1�����ÿ���
		applyObject.setAttributeValue("CR028", "5");//��90�����Ų�ѯ��������Ų�ѯԭ��Ϊ�������������Ĳ�ѯ����
		applyObject.setAttributeValue("CR014", "0");//��90�����Ų�ѯ��������Ų�ѯԭ��Ϊ�����������������ÿ��������Ĳ�ѯ����
		applyObject.setAttributeValue("CR027", "0");//���ÿ���ϸ��Ϣ�С���ǰ�����ܶ����0�����ÿ���
		applyObject.setAttributeValue("CR021", "2");//���ű������ۼ����ڴ���
		
	}
    //ѺƷ��Ϣ
	private void calRuleSimpleData_mortgageInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("parkonly", "01");//��Ѻ�����Ƿ�ֻ�г�λ
		applyObject.setAttributeValue("purchaseprice", "2000000");//�������׼�
		applyObject.setAttributeValue("EMV", "1800000");//����������
		applyObject.setAttributeValue("citytype2", "01");//�������ڳ�������
		applyObject.setAttributeValue("houseusage", "01");//������;
		applyObject.setAttributeValue("PropertyStatus", "");//����״̬
		applyObject.setAttributeValue("yearofhouse", "20");//����
		applyObject.setAttributeValue("FPcurrency", "01");//��Ʋ�Ʒ����
		applyObject.setAttributeValue("currencysame", "01");//��Ʋ�Ʒ�������������Ƿ���ͬ
		applyObject.setAttributeValue("FPexpiry", "12");//��Ʋ�Ʒʣ������
		applyObject.setAttributeValue("monthofEMV", "3");//����ʱ��
		applyObject.setAttributeValue("RMBDC", "300000");//����Ҷ��ڴ浥��ֵ
		applyObject.setAttributeValue("yearofland", "");//����ʣ��ʹ������
		applyObject.setAttributeValue("FCDC", "200000");//��Ҷ��ڴ浥��ֵ
		applyObject.setAttributeValue("ztype", "01");//��Ѻ������
 	}
	//������Ϣ
	private void calRuleSimpleData_odInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("ODperiod", "2");//������������
		applyObject.setAttributeValue("ODday", "2");//��������
	}
	//�ʲ�������Ϣ
	private void calRuleSimpleData_loanGradeInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("BaselLoanCategory", "2");//Basel��������
		applyObject.setAttributeValue("CEJMUpdate", "2");//CEJM��������
		applyObject.setAttributeValue("CEJMGrade", "2");//CEJM����
		applyObject.setAttributeValue("SYSGENGRADEupdate", "2");//SYS GEN GRADE��������
		applyObject.setAttributeValue("LoanType", "2");//����״̬
		applyObject.setAttributeValue("ACBorrowerGradeOverriding", "2");//���Ǻ�Ľ���˼���
		applyObject.setAttributeValue("ACBorrowerGrade", "2");//����˼���
		applyObject.setAttributeValue("CustomerGrade", "2");//�ͻ��ȼ�
		applyObject.setAttributeValue("CustomerGradeUpdate", "2");//�ͻ��ȼ���������
		applyObject.setAttributeValue("SpecializedLendingCode", "2");//�ر�������
		applyObject.setAttributeValue("SpecializedLendingLastUpdatedDate", "2");//�ر�������һ�θ�������
	}
}
