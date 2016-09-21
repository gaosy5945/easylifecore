package com.amarsoft.app.oci.parser;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
/**
 * 
 * @author xjzhao
 * 
 * <p>�����������ӿ�</p>
 * <p>�ýӿڸ��𽫱��Ķ���ת��Ϊ�����ͱ��ģ�<br>
 *  ͬʱҲ���𽫽��յ��ı���ת��Ϊ���Ķ���</p>
 * 
 */
public interface IParser {
	
	/**
	 * @param trans
	 * @return 
	 * ���,�����׶�������ƶ��ı��ĸ�ʽת����Ҫ���͵ı���
	 * @throws Exception 
	 */
	public void compositeTransData(OCITransaction trans) throws Exception;

	/**
	 * @param trans
	 * @return 
	 * ���,�����յ��ı��ĸ����ƶ��ı��ĸ�ʽת��Ϊ���Ķ���
	 * @throws Exception 
	 */
	public void decomposeTransData(OCITransaction trans) throws Exception;
	
}
