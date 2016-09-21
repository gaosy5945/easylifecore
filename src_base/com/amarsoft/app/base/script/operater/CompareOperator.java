package com.amarsoft.app.base.script.operater;

/**
 * 
 *ʵ���������ݶ���ıȽϣ��Ƚ�ƥ���򷵻�true����false
 *  
 *�ȽϷ�ʽ���£�
 * = ����
 * != ������
 * > ����
 * >= ���ڵ���
 * < С��
 * <= С�ڵ���
 * Start ��ͷ��
 * NoStart ��ͷ����
 * End ��β��
 * NoEnd ��β����
 * Contain ����
 * NoContain ������
 * in ������
 * not in ��������
 *  
 * @author xjzhao@amarsoft.com
 * @since 1.0
 * @since JDK1.6
 */

public abstract class CompareOperator{
	
	/**
	  * ƥ���������ݶ���
	  * @param a
	  * @param b
	  * @return ƥ����
	  * @throws Exception
	  */
	 public abstract boolean compare(Object a,Object b,Object... extendedPropoty) throws Exception;
}
