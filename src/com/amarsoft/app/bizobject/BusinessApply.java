package com.amarsoft.app.bizobject;

/**
 * 
 * @author qfang
 * 
 */
public class BusinessApply {
	
	/**
	 * 新增申请时，Flag5默认为010
	 * 登记最终意见或者登记合同时，Flag5设置为020
	 */
	public final static String PHASEFLAG_NEWAPPLY = "010";
	public final static String PHASEFLAG_NEWAPPROVEORCONTRACT = "020";
	
	
	/**
	 *业务申请信息暂存标志：
	 *	1 是 
	 * 	2 否
	 */
	public final static String TEMPSAVE_YES = "1";
	public final static String TEMPSAVE_NO = "0";
	
	/**
	 *业务品种分类标志位： 
	 * 1是
	 * 2否
	 */
	public final static String FLAGS_YES = "1";
	public final static String FLAGS_NO = "2";
	
	/**
	 *额度是否循环标志： 
	 * 1是
	 * 2否
	 */
	public final static String CYCLEFLAG_YES = "1";
	public final static String CYCLEFLAG_NO = "2";
	
	/**
	 *业务是否循环标志： 
	 * 1是
	 * 2否
	 */
	public final static String CREDITCYCLE_YES = "1";
	public final static String CREDITCYCLE_NO = "2";
	
	/**
	 *是否异地业务标志： 
	 *010非异地贷款
	 *015跨省贷款
	 *020跨市贷款
	 */
	public final static String OTHERAREALOAN_NO = "010";
	public final static String OTHERAREALOAN_YES1 = "015";
	public final static String OTHERAREALOAN_YES2 = "020";
	
	/**
	 *利率浮动方式： 
	 * 0浮动比率
	 * 1浮动点
	 */
	public final static String RATEFLOATTYPE_YES = "0";
	public final static String RATEFLOATTYPE_NO = "1";
	
	/**
	 *还款频率： 
	 * 01日
	 * 02月
	 */
	public final static String FRCODE_YES = "01";
	public final static String FRCODE_NO = "02";
	
	/**
	 *还息频率： 
	 * 01日
	 * 02月
	 */
	public final static String IPCODE_YES = "01";
	public final static String IPCODE_NO = "02";
	
}
