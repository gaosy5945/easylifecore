package com.amarsoft.app.base.util;

/**
 * ���㳣����
 */
public class ACCOUNT_CONSTANTS {
	public static int Number_Precision_Rate = 8;// ����С��λ��
	
	public static int Number_Precision_Money = 2;// ���С��λ
	
	public static final String FLAG_YES = "1";
	public static final String FLAG_NO = "0";

	// �ڹ���Ϣ����
	public static final String Instalment_Change_Flag_New = "1";// ���ڹ�
	public static final String Instalment_Change_Flag_Old = "2";// ԭ�ڹ�
	
	// ����˳�ӱ�־
	public static final String POSTPONE_PAYMENT_FLAG_Max = "1";// �����ںͽڼ���˳����ȡ��
	public static final String POSTPONE_PAYMENT_FLAG_Min = "2";// �����ںͽڼ���˳����ȡС
	public static final String POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY = "3";// �����ں����ڼ��ռ���˳��
	public static final String POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE = "4";// �ڼ���˳�Ӻ�������ܿ�����
	public static final String POSTPONE_PAYMENT_FLAG_ANY = "5";// �������

	// �������ڱ�ʶ
	public final static String DAY_WORKDAY = "1";// ������
	public final static String DAY_HOLIDAY = "2";// �ڼ���
	public final static String DAY_OFFICIAL_HOLIDAY = "3";// ������

}