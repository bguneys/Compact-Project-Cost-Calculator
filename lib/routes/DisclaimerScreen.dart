import 'package:flutter/material.dart';

class DisclaimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(
        title: Text("DISCLAIMER", style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),

      body: Container(
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                        child: Text("This software is provided as is without warranty of any kind, either express or implied, including but not limited to, the implied warranties of fitness for a purpose, or the warranty of non-infringement. Without limiting the foregoing, the developer of this software makes no warranty that: the software will meet your requirements, the software will be uninterrupted, timely, secure or error-free, the results that may be obtained from the use of the software will be effective, accurate or reliable, the quality of the software will meet your expectations, any errors in this software will be corrected.\n\nSoftware and its documentation made available here: could include technical or other mistakes, inaccuracies or typhographical errors. The developer of this software may make changes to the software or documentation, may be out of date, and the developer of this software makes no commitment to update such materials. The developer of this software assumes no responsibility for errors or ommisions in this software or documentation available. In no event shall the developer of this software be liable to you or any third parties for any special, punitive, incidental, indirect or consequential damages of any kind, or any damages whatsoever, including, without limitation, those resulting from loss of use, data or profits, whether or not the developer of this software has been advised of the possibility of such damages, and on any theory of liablity, arising out of or in connection with the use of this software. The use of this software is done at your own discretion and risk and with agreement that you will be solely responsible for any damage to your computer or mobile system or loss of data that results from such activities. No advice or information, whether oral of written, obtained by you from the developer of this software shall create any warranty for this software.\n\nTHE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE DEVELOPER OR AUTHOR OF THIS SOFTWARE BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABLITY, WHETHER IN AN ACION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\nThe disclaimer of warranties and limitation of liability provided above shall be interpreted in a manner that, to the extent possible, most closely approximates an absolute disclaimer and waiver of all liability.",
                            style: Theme.of(context).textTheme.bodyText1)
                    ),
                  )
              ),
            ],
          ),
      ) ,
    );
  }
}
