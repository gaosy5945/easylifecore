package com.amarsoft.app.als.customer.model;

public class CustomerConst {
	
	/**********************JBO对象区域*************************/
	public static final String CUSTOMER_INFO = "jbo.customer.CUSTOMER_INFO";//客户基本信息
	public static final String ENT_INFO = "jbo.customer.ENT_INFO";//对公客户详情
	public static final String IND_INFO = "jbo.customer.IND_INFO";//个人客户详情
	public static final String CUSTOMER_PARTNER = "jbo.customer.CUSTOMER_PARTNER";//合作方客户详情
	public static final String CUSTOMER_BELONG = "jbo.customer.CUSTOMER_BELONG";//客户相关权限
	public static final String PARTNER_PROJECT_INFO = "jbo.customer.PARTNER_PROJECT_INFO";//合作方项目详情
	public static final String CUSTOMER_SPECIAL = "jbo.app.CUSTOMER_SPECIAL";//特殊客户处理
	public static final String CUSTOMER_TRANSFER = "jbo.customer.CUSTOMER_TRANSFER";//客户转移记录表
	public static final String GROUP_INFO = "jbo.app.GROUP_INFO";//集团信息表
	public static final String GROUP_MEMBER_RELATIVE = "jbo.app.GROUP_MEMBER_RELATIVE";//集团成员表
	public static final String PARTNER_PROJECT_RELATIVE = "jbo.customer.PARTNER_PROJECT_RELATIVE";
	public static final String CUSTOMER_IDENTITY = "jbo.customer.CUSTOMER_IDENTITY";//校验证件
	public static final String CUSTOMER_TEL  = "jbo.customer.CUSTOMER_TEL";//客户联系电话表
	public static final String PUB_ADDRESS_INFO  = "jbo.app.PUB_ADDRESS_INFO";//客户联系地址表
	public static final String SWIFT_INFO = "jbo.customer.SWIFT_INFO";//SWIFT号码信息
	public static final String CUSTOMER_IMPORT_LOG = "jbo.customer.CUSTOMER_IMPORT_LOG";//客户引入记录表
	public static final String BUILDING_INFO = "jbo.customer.BUILDING_INFO";//楼盘信息
	public static final String BUILDING_DETAIL = "jbo.customer.BUILDING_DETAIL";//楼盘信息
	public static final String CUSTOMER_MERGE = "jbo.customer.CUSTOMER_MERGE";//楼盘信息
	public static final String CUSTOMER_ADDRESS = "jbo.app.PUB_ADDRESS_INFO";//楼盘信息
	public static final String OBJECT_TAG_CATALOG = "jbo.app.OBJECT_TAG_CATALOG";//标签定义
	public static final String OBJECT_TAG_LIBRARY = "jbo.app.OBJECT_TAG_LIBRARY";//标签分组信息
	
	public static final String EVALUATE_RECORD = "jbo.app.EVALUATE_RECORD";//测算结果
	public static final String EVALUATE_DATA = "jbo.app.EVALUATE_DATA";//测算数据
	

	/**********************代码区域*************************/
	public static final String CustomerType_01="01";/** 公司客户 */
	public static final String CUSTOMERTYPE_ENTERPRISE = "0110"; /**大型企业**/
	public static final String CUSTOMERTYPE_SMEENTERPRISE = "0120"; /**中小企业**/
	public static final String CustomerType_03="03";/**个人客户*/
	public static final String CUSTOMERTYPE_IND = "0310"; /**个体经营户**/
	public static final String CUSTOMERTYPE_INDECONOMIC = "0320"; /**个人客户**/
	public static final String CUSTOMERTYPE_ALIKE = "0610";/**金融客户**/
	
	/**客户转让类型*/
	public static final String tOperateType_10="10";//转入
	public static final String tOperateType_20="20";//转出
	/**客户转移权限类型*/
	public static final String RightType_10="10";//管户权
	public static final String RightType_20="20";//维护权
	/**客户转移状态*/
	public static final String TransferType_10="10";//未确认
	public static final String TransferType_20="20";//已确认
	public static final String TransferType_30="30";//已拒绝
	/**客户证件状态*/
	public static final String CUSTOMER_IDENTITY_STATUS_1 = "1";//客户证件有效
	public static final String CUSTOMER_IDENTITY_STATUS_2 = "2";//客户证件失效
	public static final String CUSTOMER_IDENTITY_MAINFLAG_1 = "1";//主证件
	public static final String CUSTOMER_IDENTITY_MAINFLAG_2 = "2";//不为主证件
	/**企业信息暂存标志*/
    public static final String ENT_INFO_TEMPFLAG_1 = "1";//企业信息详情暂存标志
    public static final String ENT_INFO_TEMPFLAG_0 = "0";//企业信息详情已保存标志

    /**客户权限状态*/
    public static final String CUSTOMER_BELONG_BELONGATTRIBUTE_1 = "1";//有相关权限
    public static final String CUSTOMER_BELONG_BELONGATTRIBUTE_2 = "2";//无相关权限
    
    /**项目关联类型*/
    public static final String PARTNER_RELATIVE_TYPE_1 = "Customer";//客户
    public static final String PARTNER_RELATIVE_TYPE_2 = "Product";//产品
    public static final String PARTNER_RELATIVE_TYPE_3 = "LimitProject";//项目额度
    public static final String PARTNER_RELATIVE_TYPE_4 = "LimitGuaranty";//担保额度
    public static final String PARTNER_RELATIVE_TYPE_5 = "Vehicle";//车辆
    public static final String PARTNER_RELATIVE_TYPE_6 = "Building";//楼盘
    public static final String PARTNER_RELATIVE_TYPE_7 = "WarterCraft";//船只
    public static final String PARTNER_RELATIVE_TYPE_8 = "Equipment";//设备
    public static final String PARTNER_RELATIVE_TYPE_9 = "Consigner";//委托人
    public static final String PARTNER_RELATIVE_TYPE_10 = "Project";//项目关联
    /**
     * 客户状态，01 正常
     */
    public static final String CustomerStatus_01="01";
    /**
     * 客户状态，03 失效
     */
    public static final String CustomerStatus_03="03";

    /** 客户状态，CustomerStatus 代码   */
    public static final String CustomerStatus="CustomerStatus";
	public static final String HAVENO_1 = null;
	public static final String ISNEW_1 = "0";
	public static final String ISNEW_2 = "1";
}
