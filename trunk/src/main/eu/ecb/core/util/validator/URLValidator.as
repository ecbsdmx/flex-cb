// ECB/SIS Public License, version 1.0, document reference SIS/2001/116
//
// Copyright (C) 2008 European Central Bank. All rights reserved.
//
// Redistribution and use in source and binary forms,
// with or without modification, are permitted
// provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
// Neither the name of the European Central Bank
// nor the names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
package eu.ecb.core.util.validator
{
	import mx.validators.Validator;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.collections.ArrayCollection;

	/**
	 * Provides support for URL validation.
	 * 
	 * This class is a slightly modified version, rewritten in ActionScript
	 * of the Apache common java URLValidator class. 
	 * 
	 * @author Xavier Sosnovsky
	 */
	public class URLValidator extends Validator {

		/*==============================Fields================================*/

		/**
		 * The array containing the validation results to be returned.
		 */ 
		private var _results:Array;
		
		/**
		 * The array of allowed schemes.
		 */ 
		private var _schemes:ArrayCollection;
		
		/**
		 * The URL to validate.
		 */ 
		private var _url:String;
		
		/**
		 * Whether the scheme is mandatory or not.
		 */ 
		private var _allowNoScheme:Boolean;
		
		/**
		 * Whether the path is mandatory or not
		 */ 
		private var _allowNoPath:Boolean;
		
		/**
		 * Whether the authority is mandatory or not
		 */ 
		private var _allowNoAuthority:Boolean;
		
		/*===========================Constructor==============================*/

		public function URLValidator() 
		{
			super();
			_schemes = new ArrayCollection(["http", "https"]);
		}
		
		/*============================Accessors===============================*/
		
		/**
		 * @private
		 */
		public function set allowNoScheme(allowNoScheme:Boolean):void 
		{
			_allowNoScheme = allowNoScheme;
		}
		
		/**
		 * Whether the scheme is mandatory or not
		 */ 
		public function get allowNoScheme():Boolean 
		{
			return _allowNoScheme;
		}
		
		/**
		 * @private
		 */
		public function set schemes(schemes:ArrayCollection):void 
		{
			_schemes = schemes;
		}
		
		/**
		 * The array of allowed schemes.
		 */ 
		public function get schemes():ArrayCollection 
		{
			return _schemes;
		}
		
		/**
		 * @private
		 */
		public function set allowNoPath(allowNoPath:Boolean):void 
		{
			_allowNoPath = allowNoPath;
		}
		
		/**
		 * Whether the path is mandatory or not
		 */ 
		public function get allowNoPath():Boolean 
		{
			return _allowNoPath;
		}
		
		/**
		 * @private
		 */ 
		public function set allowNoAuthority(allowNoAuthority:Boolean):void 
		{
			_allowNoAuthority = allowNoAuthority;
		}
		
		/**
		 * Whether the authority is mandatory or not
		 */ 
		public function get allowNoAuthority():Boolean 
		{
			return _allowNoAuthority;
		}
		
		/*==========================Public methods============================*/
		
		/**
		 * Validates the supplied scheme against the valid list of schemes.
		 * 
		 * Scheme names consist of a sequence of characters beginning with a 
		 * lower case letter and followed by any combination of lower case 
		 * letters, digits, plus ("+"), period ("."), or hyphen ("-"). For 
		 * resiliency, programs interpreting URI should treat upper case letters
		 * as equivalent to lower case in scheme names (e.g., allow "HTTP" as 
		 * well as "http").
		 * 
		 * @param scheme The scheme to validate
		 * 
		 * @return Whether or not the scheme is valid
		 */ 
		public function isValidScheme(scheme:String):Boolean 
		{
			var result:Boolean = false;
			if (null == scheme && _allowNoScheme) {
				result = true;
			} else if (_schemes.contains(scheme)) {
				result = true;
			}
			return result;
		}
		
		/**
		 * Validates the supplied authority (hostname + port number).
		 * 
		 * The authority is a domain name of a network host, or its IPv4 address 
		 * as a set of four decimal digit groups separated by ".". Domain names 
		 * take the form of a sequence of domain labels separated by 
		 * ".", each domain label starting and ending with an alphanumeric 
		 * character and possibly also containing "-" characters.  The rightmost 
		 * domain label of a fully qualified domain name will never start with a 
		 * digit, thus syntactically distinguishing domain names from IPv4 
		 * addresses. The port is the network port number for the server.
		 * 
		 * @param authority The authority to validate
		 * 
		 * @return Whether or not the authority is valid
		 */ 
		public function isValidAuthority(authority:String):Boolean 
		{
			if (null == authority) {
				if (allowNoAuthority) {
					return true;
				} else {
					return false;
				}
			}
			var authorityPattern:RegExp = /^([a-zA-Z0-9\-\.]*)(:[0-9]{1,5})?$/;
			if (!authorityPattern.test(authority)) {
				return false;
			}
			
			var result:Array = authorityPattern.exec(authority);
			var host:String = result[1];
			var ipV4Pattern:RegExp = 
				/^([0-9]{1,3})[\.]([0-9]{1,3})[\.]([0-9]{1,3})[\.]([0-9]{1,3})$/;
			var ipV4Address:Boolean = ipV4Pattern.test(host);
			if (ipV4Address) {
				var ipv4Result:Array = ipV4Pattern.exec(host);
				for (var i:int = 1; i <= 4; i++) {
					var ipSegment:String = ipv4Result[i];
					if (null == ipSegment || 0 == ipSegment.length) {
						return false;
					}
					if ((Number(ipSegment)) > 255) {
						return false;
					}
				}
			} else {
				var hostnamePattern:RegExp = 
					/^([a-zA-Z0-9][a-zA-Z0-9\-]+[a-zA-Z0-9][\.])+[a-zA-Z]{2,7}$/;
				var validHostname:Boolean = hostnamePattern.test(host);
				if (!validHostname) {
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Validates the supplied path.
		 * 
		 * The path component contains data, specific to the authority (or the
		 * scheme if there is no authority component), identifying the resource 
		 * within the scope of that scheme and authority. The path may consist 
		 * of a sequence of path segments separated by a single slash "/" 
		 * character. Within a path segment, the characters "/", ";", "=", and 
		 * "?" are reserved.  Each path segment may include a sequence of 
		 * parameters, indicated by the semicolon ";" character. The parameters 
		 * are not significant to the parsing of relative references.
		 * 
		 * @param path The path to validate
		 * 
		 * @return Whether or not the path is valid
		 */ 
		public function isValidPath(path:String):Boolean 
		{
			if (null == path || 0 == path.length) {
				if (_allowNoPath) {
					return true;
				} else {
					return false;
				}
			} else {
				var pathPattern:RegExp = 
					/^([a-zA-Z0-9:=&;,\$\+~\*'\(\)\-_\.!\/])+$/;
				var validPath:Boolean = pathPattern.test(path);
				if (validPath) {
					return true;
				}
			}
			return false;
		}
		
		/*=========================Protected methods==========================*/
		
		/**
		 * @private
		 */ 
		protected override function doValidation(value:Object):Array 
		{
			_url = StringUtil.trim(value as String);
			_results = super.doValidation(_url);
			if (_results.length > 0) {
				return _results;
			}
			var urlPattern:RegExp = /^(([a-zA-Z][a-zA-Z0-9\.\+\-]+):)?((\/\/)?(([a-zA-Z0-9:=&;,\$\+~\*'\(\)\-_\.!]+)@)?([a-zA-Z0-9\-\.:]*))?(\/([^?#]*))?(\?([^#]*))?(#([a-zA-Z0-9:=&;,\$\+~\*'\(\)\-_\.!]*))?/;
			if (!urlPattern.test(_url)) {
				_results.push(new ValidationResult(true, null, 
					"ErrCode 001", "The supplied url '" + _url + "' is not " + 
					"syntactically correct"));	
				return _results;	
			}
			var result:Array = urlPattern.exec(_url);
			if (!isValidScheme(result[2])) {
				_results.push(new ValidationResult(true, null, 
					"ErrCode 002", "The supplied scheme '" + result[2] + "' " + 
					"is not in the list of allowed schemes: " + _schemes));	
				return _results;	
			}
			if (!isValidAuthority(result[7])) {
				_results.push(new ValidationResult(true, null, 
					"ErrCode 003", "The supplied domain '" + result[7] + 
					"' " + "is not valid"));	
				return _results;
			}
			if (!isValidPath(result[9])) {
				_results.push(new ValidationResult(true, null, 
					"ErrCode 004", "The supplied path '" + result[9] + 
					"' " + "is not valid"));	
				return _results;
			}

			return _results;
		}
	}
}