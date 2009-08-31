%include talk.fmt
\section{Introduction}
\subsection{What is \texorpdfstring{\clash{}}{CLasH}}
\frame
{
  \frametitle{What is \clash{}?}\pause
  \begin{itemize}
    \item \clash{}: CAES Language for Hardware\pause
    \item Rapid prototyping language\pause
    \item Subset of Haskell can be translated to Hardware (VHDL)\pause
    \item Structural Description of the logic part of a Mealy Machine
  \end{itemize}
}
\note[itemize]
{
\item We are a Computer Architectures group, this has been a Masters' project, no prior experience with Haskell.
\item \clash{} is written in Haskell, of course
\item \clash{} is currently meant for rapid prototyping, not verification of hardware designs
\item Functional languages are close to Hardware
\item We can only translate a subset of Haskell
\item All functions are structural descriptions with a Mealy Machines perspective
}

\frame
{
\frametitle{Mealy Machine}
\begin{figure}
\centerline{\includegraphics<1>[width=6.25cm]{mealymachine2}
\includegraphics<2>[width=6.25cm]{mealymachine2-func-red}
\includegraphics<3>[width=6.25cm]{mealymachine2-state-red}}
\label{img:mealymachine}
\end{figure}
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
run {-"{\color<2>[rgb]{1,0,0}"-}func{-"}"-} {-"{\color<3>[rgb]{1,0,0}"-}state{-"}"-} [] = []
run {-"{\color<2>[rgb]{1,0,0}"-}func{-"}"-} {-"{\color<3>[rgb]{1,0,0}"-}state{-"}"-} (i:inputs) = o:outputs
  where
    ({-"{\color<3>[rgb]{1,0,0}"-}state'{-"}"-}, o)  =   {-"{\color<2>[rgb]{1,0,0}"-}func{-"}"-} i {-"{\color<3>[rgb]{1,0,0}"-}state{-"}"-}
    outputs                                         =   run {-"{\color<2>[rgb]{1,0,0}"-}func{-"}"-} {-"{\color<3>[rgb]{1,0,0}"-}state'{-"}"-} input
\end{code}
\end{beamercolorbox}
}
\note[itemize]{
\item A Mealy machine bases its output on the current state and the input
\item State is part of the function signature
\item Both the current state, and the updated State
\item The run function simulates a mealy machine for the provided number of inputs
}

\frame
{
\frametitle{Haskell Description}
\begin{figure}
\centerline{\includegraphics[width=6.25cm]{mealymachine2-func-red}}
\end{figure}
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
func :: 
  InputSignal ->
  State ->
  (State, OutputSignal)
\end{code}
\end{beamercolorbox}
}
\note[itemize]{
\item In \clash{} you describe the logic part of the mealy machine
\item The state in the signature is turned into memory elements when translating to VHDL
}
