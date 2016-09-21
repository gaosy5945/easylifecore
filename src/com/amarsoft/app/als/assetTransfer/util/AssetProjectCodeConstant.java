/**
 * 
 */
package com.amarsoft.app.als.assetTransfer.util;

/**
 * 描述：	代码常量
 * @author xyli
 * @2014-4-22
 */
public class AssetProjectCodeConstant {
	
	/**
	 * ProjectStatus  资产证券化涉及状态
	 */
	//待提交
	public static String ProjectStatus_01 = "01";
	//复核中
	public static String ProjectStatus_02 = "02";	
	//审查中
	public static String ProjectStatus_0201 = "0201";	
	//审批中
	public static String ProjectStatus_0202 = "0202";	
	//复核通过
	public static String ProjectStatus_03 = "03";	
	//复核否决
	public static String ProjectStatus_04 = "04";	
	//已退回
	public static String ProjectStatus_05 = "05";	
	//已封包
	public static String ProjectStatus_06 = "06";	
	//已入池
	public static String ProjectStatus_07 = "07";	
	//已失效
	public static String ProjectStatus_08 = "08";	
	


	/** 资产转让 */
	/*public static String AssetProjectType_010 = "010";*/
	
	//资产转让
	public static String AssetProjectType_010 = "0201";
	
	/** 资产受让 */
	/*public static String AssetProjectType_020 = "020";*/
	
	//资产证券化
	public static String AssetProjectType_020 = "0203";
	
	/** 回购式 */
	public static String TransferMethod_010 = "010";
	
	/** 卖断式 */
	public static String TransferMethod_020 = "020";
	
	/** 追加 */
	public static String AdjustType_010 = "010";
	
	/** 置换 */
	public static String AdjustType_020 = "020";
	
	/** 被置换 */
	public static String AdjustType_030 = "030";
	
	/** 赎回 */
	public static String AdjustType_040 = "040";
	
	/** 新建 */
	/*public static String AssetProjectStatus_010 = "010";*/
	
	//待提交
	public static String AssetProjectStatus_010 = "0"; 
	
	/** 生效 */
	/*public static String AssetProjectStatus_020 = "020";*/
	
	//复核中
	public static String AssetProjectStatus_020 = "1"; 
	
	/** 交割 */
	/*public static String AssetProjectStatus_030 = "030";*/
	
	//复核通过
	public static String AssetProjectStatus_030 = "2";
	
	/** 结清 */
	public static String AssetProjectStatus_040 = "040";
	
	/** 归档 */
	public static String AssetProjectStatus_050 = "050";
	
	//待复核资产
	public static String ProjectAssetStatus_01 = "01";
	
	//复核中资产
	public static String ProjectAssetStatus_02 = "02";
	
	//复核通过资产
	public static String ProjectAssetStatus_03 = "03";
	
	//已入池资产
	public static String ProjectAssetStatus_04 = "04";
	
	/** 有效 */
	public static String AssetRelaStatus_010 = "010";
	
	/** 无效 */
	public static String AssetRelaStatus_020 = "020";
	
	/** 赎回 */
	public static String AssetRelaStatus_030 = "030";
	
	/** 回购 */
	public static String BuyBackType_010 = "010";
	
	/** 返售 */
	public static String BuyBackType_020 = "020";
	
}
