/** @author Sameer Sheorey */
#include  "mex.h"
#include  "lift.h"
#include  "wemd.h"
#include  "blitz\array\storage.h"

#include  <vector>
using std::vector;
#include  <utility>
using std::pair;

enum dtype {SINGLE, DOUBLE};

// wd = wemdn_cpp(H, periodic, s, C0, tper, wname);
// H can be a single array or cell array. If it is a cell array, all elements
// must be same data type and same size
// periodic = array of length = ndims(H). Is this dimension periodic ?

template <class T, size_t ndims> 
void wemdn(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  const mwSize LEN = 10;            // max length of wavelet name
  char wname[LEN+1];
  float tper(0.01), s(1);
  T C0(0);
  mwSize lenh, numel;
  const mxArray *hist_ptr;
  bool *isperiodic;
  TinyVector<bool, ndims> isper(false);

  switch(nrhs)
  {
    case 0: mexErrMsgTxt("wemdn(H, periodic, s, C0, tper, wname);\n\
H can be a single array or cell array. If it is a cell array, all elements must be same data type and same size.\n\
periodic = array of length = ndims(H). Is this dimension periodic ?\n");
    case 6: mxGetString(prhs[5], wname, LEN+1);
    case 5: tper = (float)mxGetScalar(prhs[4]);
    case 4: C0 = (T)mxGetScalar(prhs[3]);
    case 3: s = (float)mxGetScalar(prhs[2]);
    case 2: isperiodic = mxGetLogicals(prhs[1]);
            if (mxGetM(prhs[1])==1)
              isper = isperiodic[0];
            else
            {
              if(mxGetM(prhs[1])!=ndims)
                mexErrMsgTxt("isperiodic array size different from histogram \
                    dimensionality.");
              for(int d=0; d<ndims; ++d)
                isper(d) = isperiodic[d];
            }
  }

  if(mxIsCell(prhs[0])) {
    lenh = mxGetNumberOfElements(prhs[0]);
    hist_ptr = mxGetCell(prhs[0], 0);
  } else {
    lenh = 1;
    hist_ptr = prhs[0];
  }

  vector<Array<T, ndims> > H;
  vector<pair<vector<unsigned>, vector<T> > > wd;

  TinyVector<int, ndims> sizeh;
  const mwSize * mwszh = mxGetDimensions(hist_ptr);
  if(ndims==1)
    sizeh[0] = std::max(mwszh[0], mwszh[1]);
  else
    for(int i=0; i<ndims; ++i)
      sizeh[i] = mwszh[i];

  for(int i=0; i<(int)lenh; ++i) 
  {
    if(i>0)
      hist_ptr = mxGetCell(prhs[0], i);
    _bz_fortranTag fortranArray;
    H.push_back(Array<T, ndims>((T *)mxGetData(hist_ptr), sizeh, 
          duplicateData,fortranArray)); 
  }

  switch(nrhs)
  {
    case 1:  numel = wemddes<T, ndims>(H, wd);                            break;
    case 2:  numel = wemddes<T, ndims>(H, wd, isper);                     break;
    case 3:  numel = wemddes<T, ndims>(H, wd, isper, s);                  break;
    case 4:  numel = wemddes<T, ndims>(H, wd, isper, s, C0);              break;
    case 5:  numel = wemddes<T, ndims>(H, wd, isper, s, C0, tper);        break;
    default: numel = wemddes<T, ndims>(H, wd, isper, s, C0, tper, wname); break;
  }

  unsigned nnz = 0;
  for(int i=0; i<(int)lenh; ++i)
    nnz += wd[i].first.size();

  plhs[0] = mxCreateSparse(numel, lenh, nnz, mxREAL);
  double *sr  = mxGetPr(plhs[0]);
  mwIndex *irs = mxGetIr(plhs[0]), *jcs = mxGetJc(plhs[0]);

  unsigned row=0;
  for(int i=0; i<(int)lenh; ++i)
  {
    jcs[i] = row;
    for(int j=0; j<wd[i].first.size(); ++j, ++row)
    {
      irs[row] = wd[i].first[j];
      sr[row] = double(wd[i].second[j]);
    }
  }
  jcs[lenh] = nnz;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  if (nrhs==0) return;
  
  const char err_wrong_type[] = 
    "Only single and double precision floats supported.\n";
  const char err_dims[] = "Too many dimensions.\n";
  const mxArray *hist_ptr;
  dtype dt(DOUBLE); 

  if(mxIsCell(prhs[0]))
    hist_ptr = mxGetCell(prhs[0], 0);
  else
    hist_ptr = prhs[0];

  if (mxIsSingle(hist_ptr))
    dt = SINGLE;
  else if(mxIsDouble(hist_ptr)) 
    dt = DOUBLE;
  else 
    mexErrMsgTxt(err_wrong_type);

  switch(mxGetNumberOfDimensions(hist_ptr))
  {
    case 2: 
      if (mxGetM(hist_ptr)==1 || mxGetN(hist_ptr)==1)   // Actually just 1 D
      {
      if (dt==SINGLE)
        wemdn<float, 1>(nlhs, plhs, nrhs, prhs);
      else
        wemdn<double, 1>(nlhs, plhs, nrhs, prhs);
      } else {
      if (dt==SINGLE)
        wemdn<float, 2>(nlhs, plhs, nrhs, prhs);
      else
        wemdn<double, 2>(nlhs, plhs, nrhs, prhs);
      }
      break;

    case 3: 
      if (dt==SINGLE)
        wemdn<float, 3>(nlhs, plhs, nrhs, prhs);

      else
        wemdn<double, 3>(nlhs, plhs, nrhs, prhs);
      break;

    case 4: 
      if (dt==SINGLE)
        wemdn<float, 4>(nlhs, plhs, nrhs, prhs);

      else
        wemdn<double, 4>(nlhs, plhs, nrhs, prhs);
      break;

    case 5: 
      if (dt==SINGLE)
        wemdn<float, 5>(nlhs, plhs, nrhs, prhs);

      else
        wemdn<double, 5>(nlhs, plhs, nrhs, prhs);
      break;

    default: mexErrMsgTxt(err_dims);
  }
}
