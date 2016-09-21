package com.amarsoft.app.base.util;

/**
 * 核算常量类
 */
public class ACCOUNT_CONSTANTS {
	public static int Number_Precision_Rate = 8;// 利率小数位数
	
	public static int Number_Precision_Money = 2;// 金额小数位
	
	public static final String FLAG_YES = "1";
	public static final String FLAG_NO = "0";

	// 期供利息计算
	public static final String Instalment_Change_Flag_New = "1";// 新期供
	public static final String Instalment_Change_Flag_Old = "2";// 原期供
	
	// 还款顺延标志
	public static final String POSTPONE_PAYMENT_FLAG_Max = "1";// 宽限期和节假日顺延日取大
	public static final String POSTPONE_PAYMENT_FLAG_Min = "2";// 宽限期和节假日顺延日取小
	public static final String POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY = "3";// 宽限期后遇节假日继续顺延
	public static final String POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE = "4";// 节假日顺延后继续享受宽限期
	public static final String POSTPONE_PAYMENT_FLAG_ANY = "5";// 任意叠加

	// 工作日期标识
	public final static String DAY_WORKDAY = "1";// 工作日
	public final static String DAY_HOLIDAY = "2";// 节假日
	public final static String DAY_OFFICIAL_HOLIDAY = "3";// 法定假

}