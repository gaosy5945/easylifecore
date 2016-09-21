package com.amarsoft.app.als.customer.model;

public class CustomerConst {
	
	/**********************JBO��������*************************/
	public static final String CUSTOMER_INFO = "jbo.customer.CUSTOMER_INFO";//�ͻ�������Ϣ
	public static final String ENT_INFO = "jbo.customer.ENT_INFO";//�Թ��ͻ�����
	public static final String IND_INFO = "jbo.customer.IND_INFO";//���˿ͻ�����
	public static final String CUSTOMER_PARTNER = "jbo.customer.CUSTOMER_PARTNER";//�������ͻ�����
	public static final String CUSTOMER_BELONG = "jbo.customer.CUSTOMER_BELONG";//�ͻ����Ȩ��
	public static final String PARTNER_PROJECT_INFO = "jbo.customer.PARTNER_PROJECT_INFO";//��������Ŀ����
	public static final String CUSTOMER_SPECIAL = "jbo.app.CUSTOMER_SPECIAL";//����ͻ�����
	public static final String CUSTOMER_TRANSFER = "jbo.customer.CUSTOMER_TRANSFER";//�ͻ�ת�Ƽ�¼��
	public static final String GROUP_INFO = "jbo.app.GROUP_INFO";//������Ϣ��
	public static final String GROUP_MEMBER_RELATIVE = "jbo.app.GROUP_MEMBER_RELATIVE";//���ų�Ա��
	public static final String PARTNER_PROJECT_RELATIVE = "jbo.customer.PARTNER_PROJECT_RELATIVE";
	public static final String CUSTOMER_IDENTITY = "jbo.customer.CUSTOMER_IDENTITY";//У��֤��
	public static final String CUSTOMER_TEL  = "jbo.customer.CUSTOMER_TEL";//�ͻ���ϵ�绰��
	public static final String PUB_ADDRESS_INFO  = "jbo.app.PUB_ADDRESS_INFO";//�ͻ���ϵ��ַ��
	public static final String SWIFT_INFO = "jbo.customer.SWIFT_INFO";//SWIFT������Ϣ
	public static final String CUSTOMER_IMPORT_LOG = "jbo.customer.CUSTOMER_IMPORT_LOG";//�ͻ������¼��
	public static final String BUILDING_INFO = "jbo.customer.BUILDING_INFO";//¥����Ϣ
	public static final String BUILDING_DETAIL = "jbo.customer.BUILDING_DETAIL";//¥����Ϣ
	public static final String CUSTOMER_MERGE = "jbo.customer.CUSTOMER_MERGE";//¥����Ϣ
	public static final String CUSTOMER_ADDRESS = "jbo.app.PUB_ADDRESS_INFO";//¥����Ϣ
	public static final String OBJECT_TAG_CATALOG = "jbo.app.OBJECT_TAG_CATALOG";//��ǩ����
	public static final String OBJECT_TAG_LIBRARY = "jbo.app.OBJECT_TAG_LIBRARY";//��ǩ������Ϣ
	
	public static final String EVALUATE_RECORD = "jbo.app.EVALUATE_RECORD";//������
	public static final String EVALUATE_DATA = "jbo.app.EVALUATE_DATA";//��������
	

	/**********************��������*************************/
	public static final String CustomerType_01="01";/** ��˾�ͻ� */
	public static final String CUSTOMERTYPE_ENTERPRISE = "0110"; /**������ҵ**/
	public static final String CUSTOMERTYPE_SMEENTERPRISE = "0120"; /**��С��ҵ**/
	public static final String CustomerType_03="03";/**���˿ͻ�*/
	public static final String CUSTOMERTYPE_IND = "0310"; /**���徭Ӫ��**/
	public static final String CUSTOMERTYPE_INDECONOMIC = "0320"; /**���˿ͻ�**/
	public static final String CUSTOMERTYPE_ALIKE = "0610";/**���ڿͻ�**/
	
	/**�ͻ�ת������*/
	public static final String tOperateType_10="10";//ת��
	public static final String tOperateType_20="20";//ת��
	/**�ͻ�ת��Ȩ������*/
	public static final String RightType_10="10";//�ܻ�Ȩ
	public static final String RightType_20="20";//ά��Ȩ
	/**�ͻ�ת��״̬*/
	public static final String TransferType_10="10";//δȷ��
	public static final String TransferType_20="20";//��ȷ��
	public static final String TransferType_30="30";//�Ѿܾ�
	/**�ͻ�֤��״̬*/
	public static final String CUSTOMER_IDENTITY_STATUS_1 = "1";//�ͻ�֤����Ч
	public static final String CUSTOMER_IDENTITY_STATUS_2 = "2";//�ͻ�֤��ʧЧ
	public static final String CUSTOMER_IDENTITY_MAINFLAG_1 = "1";//��֤��
	public static final String CUSTOMER_IDENTITY_MAINFLAG_2 = "2";//��Ϊ��֤��
	/**��ҵ��Ϣ�ݴ��־*/
    public static final String ENT_INFO_TEMPFLAG_1 = "1";//��ҵ��Ϣ�����ݴ��־
    public static final String ENT_INFO_TEMPFLAG_0 = "0";//��ҵ��Ϣ�����ѱ����־

    /**�ͻ�Ȩ��״̬*/
    public static final String CUSTOMER_BELONG_BELONGATTRIBUTE_1 = "1";//�����Ȩ��
    public static final String CUSTOMER_BELONG_BELONGATTRIBUTE_2 = "2";//�����Ȩ��
    
    /**��Ŀ��������*/
    public static final String PARTNER_RELATIVE_TYPE_1 = "Customer";//�ͻ�
    public static final String PARTNER_RELATIVE_TYPE_2 = "Product";//��Ʒ
    public static final String PARTNER_RELATIVE_TYPE_3 = "LimitProject";//��Ŀ���
    public static final String PARTNER_RELATIVE_TYPE_4 = "LimitGuaranty";//�������
    public static final String PARTNER_RELATIVE_TYPE_5 = "Vehicle";//����
    public static final String PARTNER_RELATIVE_TYPE_6 = "Building";//¥��
    public static final String PARTNER_RELATIVE_TYPE_7 = "WarterCraft";//��ֻ
    public static final String PARTNER_RELATIVE_TYPE_8 = "Equipment";//�豸
    public static final String PARTNER_RELATIVE_TYPE_9 = "Consigner";//ί����
    public static final String PARTNER_RELATIVE_TYPE_10 = "Project";//��Ŀ����
    /**
     * �ͻ�״̬��01 ����
     */
    public static final String CustomerStatus_01="01";
    /**
     * �ͻ�״̬��03 ʧЧ
     */
    public static final String CustomerStatus_03="03";

    /** �ͻ�״̬��CustomerStatus ����   */
    public static final String CustomerStatus="CustomerStatus";
	public static final String HAVENO_1 = null;
	public static final String ISNEW_1 = "0";
	public static final String ISNEW_2 = "1";
}
