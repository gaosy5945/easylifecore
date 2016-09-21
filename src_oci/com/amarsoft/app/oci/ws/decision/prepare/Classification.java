package com.amarsoft.app.oci.ws.decision.prepare;

public class Classification {
	//ҵ������
	public final static String IND_NEW_HOUSE_LOAN = "001";//����һ�ַ���������
	public final static String IND_OLD_HOUSE_LOAN = "002";//���˶��ַ���������
	public final static String IND_NEW_SUITABLE_HOUSE_LOAN = "032";//����һ�ַ���������-���ʷ�
	public final static String IND_NEW_HOUSE_FORCES_LOAN = "033";//����һ�ַ���������-������
	public final static String IND_OLD_HOUSE_RELAY_LOAN = "034";//���˶��ַ�-������
	public final static String IND_OLD_HOUSE_FORCES_LOAN = "035";//���˶��ַ�-������
	public final static String IND_BUSINESS_HOUSE_RELAY_LOAN = "036";//������ҵ�÷����Ҵ���-������
	public final static String ACC_FUND_SUITABLE_HOUSE_LOAN = "102";//���������-���ʷ�
	public final static String IND_HOUSE_BOND_LOAN = "407";//����ס��֤ȯ������
	//��ͬ״̬
	public final static String PUT_MONEY = "03";//�ѷſ�
	//��������
	public final static String MON_STABLE_INCOME = "3010";//���ȶ�����
	public final static String MON_RENT_INCOME = "3020";//���������
	public final static String MON_INVEST_INCOME = "3030";//Ͷ��������
	public final static String MON_REST_INCOME = "3040";//����������
	//�ͻ���ϵ����
	public final static String SPOUSE = "2007";//��ż
	//�������
	public final static String CONSUMEPOOL_AMT = "0105";//���Ѷ��
	public final static String WORKINGPOOL_AMT = "0106";//��Ӫ���
	//���������
	public final static String LIVE_BUSINESS_HOUSE_PROPERTY = "20";//���÷��ز��;�ס�÷��ز�
	public final static String TRAFFIC_TRANSPORT_EQUIPMENT = "40500";//��ͨ�����豸
	//�ͻ��ȼ�
	public final static String PLATINUM_CUSTOMER = "10";//�׽�ͻ�
	//����������
	public final static String MAIN_APPLICANT = "01";//��������
	public final static String COMMON_BORROW_APPLICANT = "02";//��ͬ�����
	public final static String COMMON_REPAYMENT_APPLICANT = "03";//��ͬ������
	//����ҵ���ʾ
	public final static String COMMON_BUSINESS = "01";//��ͨҵ��
	public final static String EXCEPTION_APPROVE_BUSINESS = "02";//��������ҵ��
	//�����������
	public final static String ACCUMULATION_FUND_COMBINATION_APPLY = "07";//��������ϴ������
	//��������
//	public final static String CREDIT = "005";//����
//	public final static String GUARANTEE = "010";//��֤
//	public final static String PLEDGE = "020";//��Ѻ
//	public final static String ZHIYA = "040";//��Ѻ
//	public final static String INSURE_GUARANTEE = "01020";//��Լ���ձ�֤
	//��Ҫ������ʽ
	public final static String CREDIT = "D";//����
	public final static String GUARANTEE = "C";//��֤
	public final static String PLEDGE = "B";//��Ѻ
	public final static String ZHIYA = "A";//��Ѻ
	public final static String INSURE_GUARANTEE = "01020";//��Լ���ձ�֤
	//��������
	public final static String IND_HOUSE_LOAN = "11"; //����ס������
	public final static String IND_COMMERCIAL_HOUSE_LOAN = "12";//�������÷�����
	public final static String IND_HOUSE_ACCUMULATIONFUND_LOAN = "13";//����ס�����������
	public final static String OTHER_LOAN = "99";//��������
	//����״̬
    public final static String NORMAL_LOAN = "1";//����״̬Ϊ����
    public final static String OVERDUE_LOAN = "2";//����״̬Ϊ����
    public final static String SETTLE_LOAN = "3";//����״̬Ϊ����
    public final static String BADDEBT_LOAN = "4";//����״̬Ϊ����
    public final static String ROLLOUT_LOAN = "5";//����״̬Ϊת��
    //��״̬
    public final static String NORMAL_LOANCARD = "1";//��״̬Ϊ����
    public final static String FROZEN_LOANCARD = "2";//��״̬Ϊ����
    public final static String STOPPAYMENT_LOANCARD = "3";//��״̬Ϊֹ��
    public final static String CANCELLATION_LOANCARD = "4";//��״̬Ϊ����
    public final static String BADDEBT_LOANCARD = "5";//��״̬Ϊ����
    public final static String NOTACTIVATED_LOANCARD = "6";//��״̬Ϊδ����
    //�弶����
    public final static String NORMAL_CLASS_5STATE = "1";//5������Ϊ����
    public final static String NORMAL_CLASS_5STATE_ATTENSTION = "2";//5������Ϊ��ע
    public final static String NORMAL_CLASS_5STATE_SEC = "3";//5������Ϊ�μ�
    public final static String NORMAL_CLASS_5STATE_SUS = "4";//5������Ϊ����
    public final static String NORMAL_CLASS_5STATE_LOS = "5";//5������Ϊ��ʧ
    public final static String NORMAL_CLASS_5STATE_UNKNONE = "9";//5������Ϊδ֪
    //����Ƶ��
    public final static String MONTHPAYMENT_RATING = "03";//����Ƶ��Ϊ��
    //��������
    public final static String LOCAL_RESIDENT = "01";//���س�ס����
    //��ҵ����
    public final static String FARMING = "A";//ũ���֡�������ҵ
    public final static String MINING = "B";//�ɾ�ҵ
    public final static String MANUFACTURING = "C";//����ҵ
    public final static String ENERGY = "D";//������ȼ����ˮ�������͹�Ӧҵ
    public final static String BUILDING = "E";//����ҵ
    public final static String MARKETING = "F";//������������ҵ
    public final static String TRANSPORTATION = "G";//��ͨ���䡢�ִ�������ҵ
    public final static String CATERING = "H";//ס�޺Ͳ���ҵ
    public final static String INFORMATION = "I";//��Ϣ���䡢�������������ҵ
    public final static String FINANCE = "J";//����ҵ
    public final static String HOUSING = "K";//���ز�
    public final static String LEASE = "L";//���޺��������
    public final static String SCIENCE = "M";//��ѧ�о��ͼ���������ҵ
    public final static String ENVIRONMENT = "N";//ˮ�����������͹�����ʩ����ҵ
    public final static String SERVE = "O";//������������������ҵ
    public final static String EDUCATION = "P";//����
    public final static String HEALTH = "Q";//��������ᱣ�Ϻ���ḣ��
    public final static String CULTURE = "R";//�Ļ�������������ҵ
    public final static String COMMUNITY = "S";//��������������֯
    public final static String INTERNATION = "T";//������֯
    //�ͻ���ʾ
    public final static String PEOPLE_BANK_BLACKLIST = "1020";//���к�����
    public final static String LOCAL_BANK_BLACKLIST = "1030";//���к�����
    //���ع̶�ֵ����
    public final static String SYSTEMID = "PL";//���󷽴���
    public final static String ALIAS = "PLAPPONL";//������
    public final static String SIGNATURE = "SPDB";//�����ò�������ǩ��
    public final static String INPUTDATAAREA = "SPDB";//�����Physical Layout
    public final static String OUTPUTDATAAREA = "OPLAPPOT";//�����Physical Layout
    public final static String TRACELEVEL = "16";//����DAʱ����־����
    public final static String POSITION = "0";//����λ��
    //����Ѻ����
    public final static String FINANCIAL_GUARANTY = "01";//��������ѺƷ
    public final static String TRADE_SHOULD_INCOME = "30100";//������Ӧ���˿�
    public final static String ELSE_SHOULD_INCOME = "30300";//����Ӧ���˿�
    
    /** ���Ų�ѯԭ��  - �������� */
    public final static String QUERY_REASON_LOAN = "02";
    /** ���Ų�ѯԭ��   - ���ÿ�����*/
    public final static String QUERY_REASON_CREDIT = "03";
    
    /**���в��������ű���*/
    public final static String QUERY_RESPONSE_NOTEXSISTS = "���в����ڸ��˵����ż�¼";
}
