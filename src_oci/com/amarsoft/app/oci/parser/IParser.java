package com.amarsoft.app.oci.parser;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
/**
 * 
 * @author xjzhao
 * 
 * <p>报文组包解包接口</p>
 * <p>该接口负责将报文对象转化为待发送报文，<br>
 *  同时也负责将接收到的报文转化为报文对象。</p>
 * 
 */
public interface IParser {
	
	/**
	 * @param trans
	 * @return 
	 * 组包,将交易对象根据制定的报文格式转化成要发送的报文
	 * @throws Exception 
	 */
	public void compositeTransData(OCITransaction trans) throws Exception;

	/**
	 * @param trans
	 * @return 
	 * 解包,将接收到的报文根据制定的报文格式转化为报文对象
	 * @throws Exception 
	 */
	public void decomposeTransData(OCITransaction trans) throws Exception;
	
}
